//
//  CreateColloquyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseCrashlytics

class CreateColloquyViewModel: ObservableObject {
    
    @Published var errorUpload: String?
    @Published var errorMessage: String?
    @Published var isError = false
    
    private let likeCount: ColloquyInteractionCounterServiceProtocol
    private let colloquyService: ColloquyServiceProtocol
    private let activityUpdate: ActivityUpdateProtocol
    
    init(likeCount: ColloquyInteractionCounterServiceProtocol, colloquyService: ColloquyServiceProtocol, activityUpdate: ActivityUpdateProtocol) {
        
        self.likeCount = likeCount
        self.colloquyService = colloquyService
        self.activityUpdate = activityUpdate
    }
    
    @MainActor
    func uploadColloquy(userId: String?, caption: String, locatioId: String?, activityId: String?) async {
        
        self.isError = false
        self.errorMessage = nil
        
        do {
            
            guard let uid = userId else {
                throw UserError.userNotFound
            }
            
            if caption.isEmpty {
                throw ColloquyError.captionIsEmpty
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
    }
}
