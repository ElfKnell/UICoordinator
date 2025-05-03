//
//  LikeService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/06/2024.
//

import Foundation
import Firebase

class LikeService {
    
    static func uploadLike(_ like: Like, collectionName: String) async throws {
        guard let likeDate = try? Firestore.Encoder().encode(like) else { return }
        try await Firestore.firestore().collection(collectionName).addDocument(data: likeDate)
    }
    
    static func fetchColloquyLike(cid: String, collectionName: String) async throws -> [Like] {
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName)
            .whereField("colloquyId", isEqualTo: cid)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })
    }
    
    static func fetchCurrentUsersLike(collectionName: String, currentUserId: String?) async throws -> [Like] {
        
        guard let currentUserId else { return [] }
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName)
            .whereField("userId", isEqualTo: currentUserId)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })
    }
    
    static func fetchUsersLikes(userId: String, collectionName: String) async throws -> [Like] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })
    }
    
    static func fetchColloquyUserLike(cid: String, collectionName: String, currentUserId: String?) async throws -> String? {
        guard let currentUserId else { return nil }
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName)
            .whereField("colloquyId", isEqualTo: cid)
            .whereField("ownerUid", isEqualTo: currentUserId)
            .getDocuments()
        
        let like = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return like.isEmpty ? nil : like[0].id
    }
    
    static func deleteLike(likeId: String, collectionName: String) async throws {
        try await Firestore
            .firestore()
            .collection(collectionName)
            .document(likeId)
            .delete()
    }
    
    static func fetchLikeCurrentUsers(collectionName: String, currentUserId: String?) async throws -> [Like] {
        guard let currentUserId else { return [] }
        
        let snapshot = try await Firestore
            .firestore()
            .collection(collectionName)
            .whereField("ownerUid", isEqualTo: currentUserId)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap({ try? $0.data(as: Like.self)})
        return activities.sorted(by: { $0.time.dateValue() > $1.time.dateValue() })
    }
}
