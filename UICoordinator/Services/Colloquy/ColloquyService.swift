//
//  ThreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct ColloquyService {
    static func uploadeThread(_ thread: Colloquy) async throws {
        guard let threadData = try? Firestore.Encoder().encode(thread) else { return }
        try await Firestore.firestore().collection("threads").addDocument(data: threadData)
    }
    
    static func fetchThreads() async throws -> [Colloquy] {
        let snapshot = try await Firestore
            .firestore()
            .collection("threads")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
    }
    
    static func fetchUserTreads(uid: String) async throws -> [Colloquy] {
        let snapshot = try await Firestore
            .firestore()
            .collection("threads")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let threads = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
        return threads.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
