//
//  CreateReplyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics

class CreateReplyViewModel: ObservableObject {
    
    @Published var isError = false
    @Published var isLoading = false
    @Published var messageError: String?
    
    var text: String
    
    private let colloquyService: ColloquyServiceProtocol
    private let increment: ColloquyInteractionCounterServiceProtocol
    private let contentModerator: ContentModeratorProtocol
    private let activityUpdate: ActivityUpdateProtocol
    
    init(text: String = "",
         colloquyService: ColloquyServiceProtocol,
         increment: ColloquyInteractionCounterServiceProtocol,
         contentModerator: ContentModeratorProtocol,
         activityUpdate: ActivityUpdateProtocol) {
        
        self.text = text
        self.colloquyService = colloquyService
        self.increment = increment
        self.contentModerator = contentModerator
        self.activityUpdate = activityUpdate
    }
    
    @MainActor
    func saveColloquy(colloquyId: String?, activityId: String?, userId: String?) async {
        
        isError = false
        isLoading = true
        messageError = nil
        
        do {
            
            guard let userId else {
                throw UserError.userIdNil
            }
            if self.text.isEmpty { return }
            
            let caption = self.text
            
            let analyze = try await contentModerator.moderateText(text: caption)
            
            guard !analyze else {
                throw ModerationError.invalidPost
            }
            
            if let cid = colloquyId {
                try await createReplyForColloquy(cid, userId: userId, caption: caption)
            } else if let aid = activityId {
                try await createReplyForActivity(aid, userId: userId, caption: caption)
            } else {
                return
            }
            
            self.text = ""
            
        } catch {
            isError = true
            messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
        isLoading = false
    }
    
    private func createReplyForColloquy(_ colloquyId: String,
                                        userId: String,
                                        caption: String) async throws {
        
        let reply = Colloquy(ownerUid: userId,
                             caption: caption,
                             timestamp: Timestamp(),
                             likes: 0,
                             locationId: nil,
                             ownerColloquy: colloquyId,
                             isDelete: false)
        
        try await colloquyService.uploadeColloquy(reply)
        try await increment.incrementRepliesCount(colloquyId: colloquyId)
        
    }
    
    private func createReplyForActivity(_ activityId: String,
                                        userId: String,
                                        caption: String) async throws {
        
        let colloquy = Colloquy(ownerUid: userId,
                                caption: caption,
                                timestamp: Timestamp(),
                                likes: 0,
                                locationId: nil,
                                ownerColloquy: activityId,
                                isDelete: false)
        
        try await colloquyService.uploadeColloquy(colloquy)
        
        try await activityUpdate.incrementRepliesCount(activityId: activityId)
        
    }
    
}
