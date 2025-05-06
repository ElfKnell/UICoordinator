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
    
    func fetchFollow(uid: String, byField: FieldToFetchingFollow) async -> [Follow] {
        
        do {
            
            return try await firestoreService.getFollows(uid: uid, followField: byField)
            
        } catch FollowError.invalidInput {
            print("ERROR Fetching \(byField.value): \(FollowError.invalidInput.description)")
            return []
        } catch {
            print("ERROR Fetching \(byField.value): \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchFollowCount(uid: String, byField: FieldToFetchingFollow) async -> Int {
        
        do {
            return try await firestoreService.getFollowCount(uid: uid, followField: byField)
        } catch FollowError.invalidInput {
            print("ERROR Fettching \(byField.value) count: \(FollowError.invalidInput.description)")
            return 0
        } catch {
            print("ERROR Fettching \(byField.value) count: \(error.localizedDescription)")
            return 0
        }
    }
}
