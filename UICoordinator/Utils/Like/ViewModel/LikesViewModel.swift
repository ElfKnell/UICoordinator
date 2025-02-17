//
//  ColloquyCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/05/2024.
//

import Foundation
import Firebase

class LikesViewModel: ObservableObject {
    @Published var collectionName: String
    @Published var likeId: String?
    
    init(likeId: String? = nil, collectionName: String) {
        self.likeId = likeId
        self.collectionName = collectionName
    }
    
    func doLike(userId: String, colloquyId: String) async throws {
        if self.likeId == nil {
            try await createLike( userId: userId, colloquyId: colloquyId)
        } else {
            try await deleteLike()
        }
    }
    
    func createLike(userId: String, colloquyId: String) async throws {
        guard let currentUserId = UserService.shared.currentUser?.id else { return }
        
        let like = Like(ownerUid: currentUserId, userId: userId, colloquyId: colloquyId, time: Timestamp())
        
        try await LikeService.uploadLike(like, collectionName: collectionName)
        try await isLike(cid: colloquyId)
    }
    
    @MainActor
    func isLike(cid: String) async throws {
        guard let id = try await LikeService.fetchColloquyUserLike(cid: cid, collectionName: collectionName) else { return }
        self.likeId = id
    }
    
    @MainActor
    func deleteLike() async throws {
        if let likeId = self.likeId {
            try await LikeService.deleteLike(likeId: likeId, collectionName: collectionName)
            self.likeId = nil
        }
    }
}
