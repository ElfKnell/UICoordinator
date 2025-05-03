//
//  FirestoreFollowService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation
import Firebase

class FirestoreFollowService: FirestoreFollowServiceProtocol {
    
    //var db = Firestore.firestore()
    
    func getFollows(uid: String, followField: FieldToFetching) async throws -> [Follow] {
        
        guard !uid.isEmpty else {
            throw FollowError.invalidInput
        }
        
        let snapshot = try await Firestore.firestore()
            .collection("Follow")
            .whereField(followField.value, isEqualTo: uid)
            .getDocuments()
        
        let followers = snapshot.documents.compactMap({ try? $0.data(as: Follow.self)})
        if followers.isEmpty { return [] }
        
        return followers.sorted(by: { $0.updateTime.dateValue() < $1.updateTime.dateValue() })
    }
    
    func getFollowCount(uid: String, followField: FieldToFetching) async throws -> Int {
        
        guard !uid.isEmpty else {
            throw FollowError.invalidInput
        }
        
        let query = Firestore.firestore()
            .collection("Follow")
            .whereField(followField.value, isEqualTo: uid)
        
        let snapshot = try await query.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
        
    }
}
