//
//  CreateColloquyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase

class CreateColloquyViewModel: ObservableObject {
    
    @Published var errorUpload: String?
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
        
        guard let uid = userId else { return }
        
        if caption.isEmpty { return }
        
        let colloquy = Colloquy(ownerUid: uid, caption: caption, timestamp: Timestamp(), likes: 0, locationId: locatioId, ownerColloquy: activityId ?? "", isDelete: false)
        
        await colloquyService.uploadeColloquy(colloquy)
        
        if let activityId = activityId {
            await activityUpdate.incrementRepliesCount(activityId: activityId)
        }
    }
}
