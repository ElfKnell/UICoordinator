//
//  FetchLikesService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Foundation
import Firebase

class FetchLikesService: FetchLikesServiceProtocol {
    
    private let likeRepository: FirestoreLikeRepositoryProtocol
    
    init(likeRepository: FirestoreLikeRepositoryProtocol) {
        self.likeRepository = likeRepository
    }
    
    func getLikeByColloquyAndUser(collectionName: CollectionNameForLike,
                                  colloquyId: String,
                                  userId: String?) async throws -> String? {
        
        guard let userId else { throw LikeError.userIdNil }
        
        let like = try await likeRepository
            .getLikeByColloquyAndUser(
                collectionName: collectionName,
                colloquyId: colloquyId,
                userId: userId
            )
        
        return like
        
    }
    
    func getLikes(collectionName: CollectionNameForLike,
                  byField field: FieldToFetchingLike,
                  userId: String?) async throws -> [Like] {
        
        guard let userId else { throw LikeError.userIdNil }
        
        let likes = try await likeRepository
            .getLikes(collectionName: collectionName, byField: field, userId: userId)
        
        return likes
        
    }
}
