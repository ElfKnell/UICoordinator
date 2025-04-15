//
//  FollowService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import FirebaseFirestoreSwift

class FollowService {
    
    private static let nameCollection = "Follow"
    
    static func uploadeFollow(_ follow: Follow) async throws {
        guard let followData = try? Firestore.Encoder().encode(follow) else { return }
        try await Firestore.firestore().collection(nameCollection).addDocument(data: followData)
    }
    
    static func fitchFollow(uid: String, follow: String) async throws -> [Follow] {
        let snapshot = try await Firestore
            .firestore()
            .collection(nameCollection)
            .whereField(follow, isEqualTo: uid)
            .getDocuments()
        
        let followers = snapshot.documents.compactMap({ try? $0.data(as: Follow.self)})
        return followers.sorted(by: { $0.updateTime.dateValue() < $1.updateTime.dateValue() })
    }
    
    static func deleteFollow(followId : String) async throws {
        try await Firestore
            .firestore()
            .collection(nameCollection)
            .document(followId)
            .delete()
    }
    
    static func fitchFollowCoutn(uid: String, follow: String) async throws -> Int {
        
        let query = Firestore
            .firestore()
            .collection(nameCollection)
            .whereField(follow, isEqualTo: uid)
        
        let snapshot = try await query.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}
