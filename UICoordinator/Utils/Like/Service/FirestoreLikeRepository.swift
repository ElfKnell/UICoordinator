//
//  FirestoreLike.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Firebase

class FirestoreLikeRepository: FirestoreLikeRepositoryProtocol {
    
    func getLikes(collectionName: CollectionNameForLike,
                  byField field: FieldToFetchingLike,
                  userId: String) async throws -> [Like] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName.value)
            .whereField(field.value, isEqualTo: userId)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
    }
    
    func getLikeByColloquyAndUser(collectionName: CollectionNameForLike,
                                  colloquyId: String,
                                  userId: String) async throws -> String? {
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName.value)
            .whereField("colloquyId", isEqualTo: colloquyId)
            .whereField("ownerUid", isEqualTo: userId)
            .getDocuments()
        
        let like = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return like.isEmpty ? nil : like[0].id
    } 
}
