//
//  LikesDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/06/2025.
//

import Foundation
import Firebase

class LikesDeleteService: LikesDeleteServiceProtocol {
    
    let likeServise: LikeServiceProtocol
    
    init(likeServise: LikeServiceProtocol) {
        self.likeServise = likeServise
    }
    
    func likesDelete(objectId: String, collectionName: CollectionNameForLike) async {
        
        do {
            
            let snapshot = try await Firestore
                .firestore()
                .collection(collectionName.value)
                .whereField("colloquyId", isEqualTo: objectId)
                .getDocuments()
            
            let likes = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
            
            if likes.isEmpty { return }
            
            for like in likes {
                await likeServise.deleteLike(likeId: like.id, collectionName: collectionName)
            }
            
        } catch {
            print("ERROR DELETE LIKES BY IDs: \(error.localizedDescription)")
        }
    } 
}
