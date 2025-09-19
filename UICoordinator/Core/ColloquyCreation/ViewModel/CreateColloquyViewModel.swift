//
//  CreateColloquyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseCrashlytics

class CreateColloquyViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var isError = false
    @Published var isLoading = false
    
    private let likeCount: ColloquyInteractionCounterServiceProtocol
    private let colloquyService: ColloquyServiceProtocol
    private let activityUpdate: ActivityUpdateProtocol
    private let contentModerator: ContentModeratorProtocol
    
    init(likeCount: ColloquyInteractionCounterServiceProtocol,
         colloquyService: ColloquyServiceProtocol,
         activityUpdate: ActivityUpdateProtocol,
         contentModerator: ContentModeratorProtocol) {
        
        self.likeCount = likeCount
        self.colloquyService = colloquyService
        self.activityUpdate = activityUpdate
        self.contentModerator = contentModerator
    }
    
    @MainActor
    func uploadColloquy(userId: String?, caption: String, locatioId: String?, activityId: String?) async {
        
        self.isLoading = true
        self.isError = false
        self.errorMessage = nil
        
        do {
            
            guard let uid = userId else {
                throw UserError.userNotFound
            }
            
            if caption.isEmpty {
                throw ColloquyError.captionIsEmpty
            }
            
            let analyze = try await contentModerator
                .analyzeTextWithAlamofire(input: caption, model: .analyzeText)
            
            if analyze.label.contains("Negative") {
                throw ModerationError.invalidPost
            }
            
            let colloquy = Colloquy(ownerUid: uid, caption: caption, timestamp: Timestamp(), likes: 0, locationId: locatioId, ownerColloquy: activityId ?? "", isDelete: false)
            
            try await colloquyService.uploadeColloquy(colloquy)
            
            if let activityId = activityId {
                try await activityUpdate.incrementRepliesCount(activityId: activityId)
            }
            
        } catch {
            self.isError = true
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
        self.isLoading = false
    }
}
