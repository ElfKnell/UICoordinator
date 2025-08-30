//
//  FetchingFollowAndFollowCount.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/04/2025.
//

import Foundation

class FetchingFollowAndFollowCount: FetchingFollowAndFollowCountProtocol {
    
    let firestoreService: FirestoreFollowServiceProtocol

    init(firestoreService: FirestoreFollowServiceProtocol) {
        self.firestoreService = firestoreService
    }
    
    func fetchFollow(uid: String, byField: FieldToFetchingFollow) async throws -> [Follow] {
        
        return try await firestoreService.getFollows(uid: uid, followField: byField)
        
    }
    
    func fetchFollowCount(uid: String, byField: FieldToFetchingFollow) async throws -> Int {
        
        return try await firestoreService.getFollowCount(uid: uid, followField: byField)
    }
}
