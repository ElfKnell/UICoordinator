//
//  ThreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ColloquyService {
    
    static func uploadeColloquy(_ colloquy: Colloquy) async throws {
        guard let colloquyData = try? Firestore.Encoder().encode(colloquy) else { return }
        try await Firestore.firestore().collection("colloquies").addDocument(data: colloquyData)
    }
    
    static func fetchColloquy(withCid cid: String) async throws -> Colloquy {
        let snapshot = try await Firestore.firestore().collection("colloquies").document(cid).getDocument()
        return try snapshot.data(as: Colloquy.self)
    }
    
    static func updateLikeCount(colloquyId: String, countLikes: Int) async throws {
        do {
            try await Firestore.firestore()
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["likes": countLikes])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func incrementRepliesCount(colloquyId: String) async throws {
        do {
            try await Firestore.firestore()
                .collection("colloquies")
                .document(colloquyId)
                .updateData(["repliesCount": FieldValue.increment(Int64(1)) ])

        } catch {
            print(error.localizedDescription)
        }
    }

}
