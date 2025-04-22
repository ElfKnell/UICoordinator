//
//  ColloquyCellViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/05/2024.
//

import Foundation
import Firebase
import Swift

class LikesViewModel: ObservableObject {
    @Published var collectionName: String
    @Published var likeId: String?
    
    init(likeId: String? = nil, collectionName: String) {
        self.likeId = likeId
        self.collectionName = collectionName
    }
    
    func doLike<T: Identifiable>(userId: String, likeToObject:T) async {
        
        if self.likeId == nil {
            await createLike( userId: userId, colloquyId: likeToObject.id as! String)
            await addLikeToObject(likeToObject)
        } else {
            await deleteLike()
            await subtractLikeToObject(likeToObject)
        }
    }
    
    private func createLike(userId: String, colloquyId: String) async {
        
        do {
            guard let currentUserId = CurrentUserService.sharedCurrent.currentUser?.id else { return }
            
            let like = Like(ownerUid: currentUserId, userId: userId, colloquyId: colloquyId, time: Timestamp())
            
            try await LikeService.uploadLike(like, collectionName: collectionName)
            await isLike(cid: colloquyId)
        } catch {
            print("ERROR CREATE LIKE: \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    func isLike(cid: String) async {
        
        do {
            guard let id = try await LikeService.fetchColloquyUserLike(cid: cid, collectionName: collectionName) else { return }
            self.likeId = id
        } catch {
            print("ERROR IS LIKE: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func deleteLike() async {
        
        do {
            if let likeId = self.likeId {
                try await LikeService.deleteLike(likeId: likeId, collectionName: collectionName)
                self.likeId = nil
            }
        } catch {
            print("ERROR DELETE LIKE: \(error.localizedDescription)")
        }
    }
    
    private func addLikeToObject<T>(_ object: T) async {
        do {
            if let colloquy = object as? Colloquy {
                try await ColloquyService.updateLikeCount(colloquyId: colloquy.id, countLikes: colloquy.likes + 1)
            } else if let activity = object as? Activity {
                try await ActivityService.updateLikeCount(activityId: activity.id, countLikes: activity.likes + 1)
            } else {
                throw LikeError.invalidType
            }
        } catch LikeError.invalidType {
            print("ERROR: \(LikeError.invalidType.description)")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    private func subtractLikeToObject<T>(_ object: T) async {
        do {
            if let colloquy = object as? Colloquy {
                let countLike = colloquy.likes - 1 > 0 ? colloquy.likes - 1 : 0
                try await ColloquyService.updateLikeCount(colloquyId: colloquy.id, countLikes: countLike)
            } else if let activity = object as? Activity {
                let countLike = activity.likes - 1 > 0 ? activity.likes - 1 : 0
                try await ActivityService.updateLikeCount(activityId: activity.id, countLikes: countLike)
            } else {
                throw LikeError.invalidType
            }
        } catch LikeError.invalidType {
            print("ERROR: \(LikeError.invalidType.description)")
        } catch {
            print("ERROR SUBTRACT LIKE: \(error.localizedDescription)")
        }
    }
}
