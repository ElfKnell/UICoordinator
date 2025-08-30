//
//  ColloquyCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/05/2024.
//

import Foundation
import Firebase
import FirebaseCrashlytics
import Swift

class LikesViewModel: ObservableObject {
    @Published var collectionName: CollectionNameForLike
    @Published var likeId: String?
    
    private let likeCount: ColloquyInteractionCounterServiceProtocol
    private let likeService: LikeServiceProtocol
    private let fethingLike: FetchLikesServiceProtocol
    private let activityUpdate: ActivityUpdateProtocol
    
    init(likeId: String? = nil, collectionName: CollectionNameForLike,
         likeCount: ColloquyInteractionCounterServiceProtocol,
         likeService: LikeServiceProtocol,
         fethingLike: FetchLikesServiceProtocol,
         activityUpdate: ActivityUpdateProtocol) {
        
        self.likeId = likeId
        self.collectionName = collectionName
        self.likeCount = likeCount
        self.likeService = likeService
        self.fethingLike = fethingLike
        self.activityUpdate = activityUpdate
    }
    
    func doLike<T: Identifiable>(userId: String, currentUserId: String?,  likeToObject:T) async {
        
        do {
            
            if self.likeId == nil {
                
                guard let currentUserId else {
                    throw UserError.userIdNil
                }
                
                try await createLike(
                    userId: userId,
                    currentUserId: currentUserId,
                    colloquyId: likeToObject.id as! String
                )
                
                try await addLikeToObject(likeToObject)
                
            } else {
                
                try await deleteLike()
                try await subtractLikeToObject(likeToObject)
                
            }
            
        } catch {
            Crashlytics.crashlytics()
                .setCustomValue("\(T.self)", forKey: "like_object_type")
            
            Crashlytics.crashlytics()
                .setCustomValue(userId, forKey: "target_user_id")
            
            Crashlytics.crashlytics()
                .setCustomValue(currentUserId ?? "nil", forKey: "current_user_id")
            
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    
    private func createLike(userId: String, currentUserId: String, colloquyId: String) async throws {
        
        let like = Like(ownerUid: currentUserId, userId: userId, colloquyId: colloquyId, time: Timestamp())
        
        try await likeService.uploadLike(like, collectionName: collectionName)
        await isLike(cid: colloquyId, currentUserId: currentUserId)
        
    }
    
    @MainActor
    func isLike(cid: String, currentUserId: String?) async {
        
        do {
            let id = try await fethingLike.getLikeByColloquyAndUser(collectionName: collectionName, colloquyId: cid, userId: currentUserId)
            self.likeId = id
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    
    @MainActor
    private func deleteLike() async throws {
        
        if let likeId = self.likeId {
            try await likeService.deleteLike(likeId: likeId, collectionName: collectionName)
            self.likeId = nil
        }
        
    }
    
    private func addLikeToObject<T>(_ object: T) async throws {
        
        if let colloquy = object as? Colloquy {
            try await likeCount.updateLikeCount(colloquyId: colloquy.id, countLikes: colloquy.likes + 1)
        } else if let activity = object as? Activity {
            try await activityUpdate.updateLikeCount(activityId: activity.id, countLikes: activity.likes + 1)
        } else {
            throw UserError.invalidType
        }
        
    }
    
    private func subtractLikeToObject<T>(_ object: T) async throws {
        
        if let colloquy = object as? Colloquy {
            let countLike = colloquy.likes - 1 > 0 ? colloquy.likes - 1 : 0
            try await likeCount.updateLikeCount(colloquyId: colloquy.id, countLikes: countLike)
        } else if let activity = object as? Activity {
            let countLike = activity.likes - 1 > 0 ? activity.likes - 1 : 0
            try await activityUpdate.updateLikeCount(activityId: activity.id, countLikes: countLike)
        } else {
            throw UserError.invalidType
        }
        
    }
}
