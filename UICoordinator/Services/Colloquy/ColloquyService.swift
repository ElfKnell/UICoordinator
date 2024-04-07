//
//  ThreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct ColloquyService {
    static func uploadeColloquy(_ colloquy: Colloquy) async throws {
        guard let colloquyData = try? Firestore.Encoder().encode(colloquy) else { return }
        try await Firestore.firestore().collection("colloquies").addDocument(data: colloquyData)
    }
    
    static func fetchColloquies() async throws -> [Colloquy] {
        let snapshot = try await Firestore
            .firestore()
            .collection("colloquies")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
    }
    
    static func fetchUserColloquy(uid: String) async throws -> [Colloquy] {
        let snapshot = try await Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        let colloquies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
        return colloquies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
