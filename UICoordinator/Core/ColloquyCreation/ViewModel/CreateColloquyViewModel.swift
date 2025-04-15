//
//  CreateColloquyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase

class CreateColloquyViewModel: ObservableObject {
    
    @Published var errorUpload: String?
    
    @MainActor
    func uploadColloquy(caption: String, locatioId: String?, ownerColloquy: String?, activityId: String?) async {
        
        do {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let colloquy = Colloquy(ownerUid: uid, caption: caption, timestamp: Timestamp(), likes: 0, locationId: locatioId, ownerColloquy: ownerColloquy ?? activityId)
            
            try await ColloquyService.uploadeColloquy(colloquy)
            if let ownerColloquy = ownerColloquy {
                try await ColloquyService.incrementRepliesCount(colloquyId: ownerColloquy)
            } else if let activityId = activityId {
                try await ActivityService.incrementRepliesCount(activityId: activityId)
            }
            
        } catch {
            errorUpload = String("Colloquy upload error: \(error.localizedDescription)")
        }
    }
}
