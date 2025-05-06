//
//  FirestoreAbstraction.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/05/2025.
//

import Firebase
import Foundation

protocol FirestoreLikeRepositoryProtocol {
    
    func getLikes(collectionName: CollectionNameForLike,
                  byField field: FieldToFetchingLike,
                  userId id: String) async throws -> [Like]
    
    func getLikeByColloquyAndUser(collectionName: CollectionNameForLike,
                                  colloquyId: String,
                                  userId: String) async throws -> String?
    
}
