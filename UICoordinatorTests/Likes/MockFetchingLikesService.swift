//
//  MockFetchingLikesService.swift
//  UICoordinatorTests
//
//  Created by Andrii Kyrychenko on 04/05/2025.
//

import Firebase
import Testing
import Foundation

class MockFetchingLikesService: FetchLikesServiceProtocol {
    
    var mockLikers: [Like] = []
    var mockLike: String?
    
    func getLikes(collectionName: CollectionNameForLike,
                  byField field: FieldToFetchingLike,
                  userId id: String?) async -> [Like] {
        
        return mockLikers
    }
    
    func getLikeByColloquyAndUser(collectionName: CollectionNameForLike,
                                  colloquyId: String,
                                  userId: String?) async -> String? {
        
        return mockLike
    }
}

class MockFirestoreLikeRepository: FirestoreLikeRepositoryProtocol {
    
    var mockLikesRepository: [Like] = [Like(likeId: "like11", ownerUid: "ownerUser1", userId: "user1", colloquyId: "colloquy1", time: Timestamp())]
    var mockLikeRepository: String? = "mock_like_id"
    var shouldThrowGenericError = false
    
    func getLikes(collectionName: CollectionNameForLike, byField field: FieldToFetchingLike, userId id: String) async throws -> [Like] {
        
        if shouldThrowGenericError { throw NSError(domain: "Test", code: 0) }
        return mockLikesRepository
    }
    
    func getLikeByColloquyAndUser(collectionName: CollectionNameForLike, colloquyId: String, userId: String) async throws -> String? {
        
        if shouldThrowGenericError { throw NSError(domain: "Test", code: 1) }
        return mockLikeRepository
    }
    
    
}
