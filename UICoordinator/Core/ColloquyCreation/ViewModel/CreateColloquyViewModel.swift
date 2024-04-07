//
//  CreateThreadViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase

class CreateThreadViewModel: ObservableObject {
    
    @MainActor
    func uploadColloquy(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let colloquy = Colloquy(ownerUid: uid, caption: caption, timestamp: Timestamp(), likes: 0)
        try await ColloquyService.uploadeColloquy(colloquy)
    }
}
