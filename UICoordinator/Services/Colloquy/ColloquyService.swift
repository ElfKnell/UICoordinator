//
//  ThreadService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

//import Firebase
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ColloquyService {
    
    static var lastDocument: DocumentSnapshot?
    
    static func uploadeColloquy(_ colloquy: Colloquy) async throws {
        guard let colloquyData = try? Firestore.Encoder().encode(colloquy) else { return }
        try await Firestore.firestore().collection("colloquies").addDocument(data: colloquyData)
    }
    
    static func fetchColloquies(usersId: [String], pageSize: Int) async throws -> [Colloquy] {
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
        
        if !usersId.isEmpty {
            query = query.whereField("ownerUid", in: usersId)
        }
        
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        self.lastDocument = snapshot.documents.last
        
        return snapshot.documents.compactMap { document in
            let colloquy = try? document.data(as: Colloquy.self)
            
            if colloquy?.ownerColloquy == nil {
                return colloquy
            } else {
                return nil
            }
        }
    }
    
    static func fetchUserColloquy(uid: String, pageSize: Int) async throws -> [Colloquy] {
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
            
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        self.lastDocument = snapshot.documents.last
        
        return snapshot.documents.compactMap { document in
            let colloquy = try? document.data(as: Colloquy.self)
            
            if colloquy?.ownerColloquy == nil {
                return colloquy
            } else {
                return nil
            }
        }
    }
    
    static func fetchColloquy(withCid cid: String) async throws -> Colloquy {
        let snapshot = try await Firestore.firestore().collection("colloquies").document(cid).getDocument()
        return try snapshot.data(as: Colloquy.self)
    }
    
    static func fetchReplies(with cid: String) async throws -> [Colloquy] {
        let snapshot = try await Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerColloquy", isEqualTo: cid)
            .getDocuments()
        
        let colloquies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
        return colloquies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
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
    
    static func fetchUserColloquyHasReplies(uid: String, pageSize: Int) async throws -> [Colloquy] {
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("repliesCount", isGreaterThan: 0)
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
            
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        self.lastDocument = snapshot.documents.last
        
        return snapshot.documents.compactMap { document in
            let colloquy = try? document.data(as: Colloquy.self)
            
            if colloquy?.ownerColloquy == nil {
                return colloquy
            } else {
                return nil
            }
        }
    }
}
