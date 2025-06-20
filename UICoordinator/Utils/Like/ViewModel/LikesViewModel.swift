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
    @Published var collectionName: CollectionNameForLike
    @Published var likeId: String?
    
    private let likeCount: ColloquyInteractionCounterServiceProtocol //ColloquyInteractionCounterService()
    private let likeService: LikeServiceProtocol //LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                          //serviceDetete: FirestoreGeneralDeleteService())
    private let fethingLike: FetchLikesServiceProtocol //FetchLikesService(likeRepository: FirestoreLikeRepository())
    private let activityUpdate: ActivityUpdateProtocol //ActivityServiceUpdate()
    
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
        
        if self.likeId == nil {
            guard let currentUserId else { return }
            await createLike( userId: userId, currentUserId: currentUserId, colloquyId: likeToObject.id as! String)
            await addLikeToObject(likeToObject)
        } else {
            await deleteLike()
            await subtractLikeToObject(likeToObject)
        }
    }
    
    private func createLike(userId: String, currentUserId: String, colloquyId: String) async {
        
        let like = Like(ownerUid: currentUserId, userId: userId, colloquyId: colloquyId, time: Timestamp())
        
        await likeService.uploadLike(like, collectionName: collectionName)
        await isLike(cid: colloquyId, currentUserId: currentUserId)
        
    }
    
    @MainActor
    func isLike(cid: String, currentUserId: String?) async {
        
        let id = await fethingLike.getLikeByColloquyAndUser(collectionName: collectionName, colloquyId: cid, userId: currentUserId)
        self.likeId = id
        
    }
    
    @MainActor
    private func deleteLike() async {
        
        if let likeId = self.likeId {
            await likeService.deleteLike(likeId: likeId, collectionName: collectionName)
            self.likeId = nil
        }
        
    }
    
    private func addLikeToObject<T>(_ object: T) async {
        
        do {
            if let colloquy = object as? Colloquy {
                await likeCount.updateLikeCount(colloquyId: colloquy.id, countLikes: colloquy.likes + 1)
            } else if let activity = object as? Activity {
                await activityUpdate.updateLikeCount(activityId: activity.id, countLikes: activity.likes + 1)
            } else {
                throw UserError.invalidType
            }
        } catch UserError.invalidType {
            print("ERROR: \(UserError.invalidType.description)")
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    private func subtractLikeToObject<T>(_ object: T) async {
        
        do {
            if let colloquy = object as? Colloquy {
                let countLike = colloquy.likes - 1 > 0 ? colloquy.likes - 1 : 0
                await likeCount.updateLikeCount(colloquyId: colloquy.id, countLikes: countLike)
            } else if let activity = object as? Activity {
                let countLike = activity.likes - 1 > 0 ? activity.likes - 1 : 0
                await activityUpdate.updateLikeCount(activityId: activity.id, countLikes: countLike)
            } else {
                throw UserError.invalidType
            }
        } catch UserError.invalidType {
            print("ERROR: \(UserError.invalidType.description)")
        } catch {
            print("ERROR SUBTRACT LIKE: \(error.localizedDescription)")
        }
    }
}
