//
//  ColloquyInteractionCounterService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/05/2025.
//

import Firebase
import Foundation

class ColloquyInteractionCounterService: ColloquyInteractionCounterServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func updateLikeCount(colloquyId: String, countLikes: Int) async {
        
        do {
            try await db
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["likes": countLikes])

        } catch {
            print("ERROR Update count Likes \(error.localizedDescription)")
        }
    }
    
    func incrementRepliesCount(colloquyId: String) async {
        
        do {
            try await db
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["repliesCount": FieldValue.increment(Int64(1)) ])

        } catch {
            print("ERROR increment replies \(error.localizedDescription)")
        }
    }
    
    
}
