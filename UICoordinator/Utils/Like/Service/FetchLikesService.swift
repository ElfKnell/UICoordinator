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
                                  userId: String?) async -> String? {
        
        do {
            
            guard let userId else { throw LikeError.userIdNil }
            
            let like = try await likeRepository.getLikeByColloquyAndUser(collectionName: collectionName, colloquyId: colloquyId, userId: userId)
            return like
            
        } catch LikeError.userIdNil {
            print("ERROR with fetching like, collectionName - \(collectionName.value) \(LikeError.userIdNil.value)")
            return nil
        } catch {
            print("ERROR with fetching like, collectionName - \(collectionName.value) \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func getLikes(collectionName: CollectionNameForLike,
                  byField field: FieldToFetchingLike,
                  userId: String?) async -> [Like] {
        
        do {
            guard let userId else { throw LikeError.userIdNil }
            
            let likes = try await likeRepository.getLikes(collectionName: collectionName, byField: field, userId: userId)
            return likes
            
        } catch LikeError.userIdNil {
            print("ERROR with fetching like, collectionName - \(collectionName.value) \(LikeError.userIdNil.value)")
            return []
        } catch {
            print("ERROR with fetching likes, collectionName - \(collectionName.value) \(error.localizedDescription)")
            return []
        }
    }
}
