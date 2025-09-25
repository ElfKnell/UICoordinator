//
//  FetchRepliesFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

actor FetchRepliesFirebase: FetchRepliesProtocol {
    
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var lastDocumentColloquy: DocumentSnapshot?
    private var isDataLoadedColloquy = false
    
    private var fetchLocation: FetchLocationFormFirebaseProtocol
    private var userService: UserServiceProtocol
    
    init(fetchLocation: FetchLocationFormFirebaseProtocol, userService: UserServiceProtocol) {
        
        self.fetchLocation = fetchLocation
        self.userService = userService
    }
    
    func getReplies(userId: String, localUsers: [User], pageSize: Int) async throws -> [Colloquy] {
        
        if isDataLoaded { return [] }
        
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("repliesCount", isGreaterThan: 0)
            .whereField("ownerUid", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
            
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isDataLoaded = true
            return []
        }
        
        self.lastDocument = snapshot.documents.last
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self) })
        
        replies = try await addUserAndLocation(replies: replies, localUsers: localUsers)
        
        return replies
        
    }
    
    func getReplies(
        colloquyId: String,
        localUsers: [User],
        pageSize: Int,
        ordering: Bool) async throws -> [Colloquy] {
        
        if isDataLoadedColloquy { return [] }
        
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerColloquy", isEqualTo: colloquyId)
            .whereField("isDelete", isEqualTo: false)
            .order(by: "timestamp", descending: ordering)
            .limit(to: pageSize)
            
        if let lastDoc = lastDocumentColloquy {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isDataLoadedColloquy = true
            return []
        }
        
        self.lastDocumentColloquy = snapshot.documents.last
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
        
        replies =  try await addUserAndLocation(replies: replies, localUsers: localUsers)
        
        return replies
        
    }
    
    func getRepliesByColloquy(colloquyId: String) async throws -> [Colloquy] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerColloquy", isEqualTo: colloquyId)
            .whereField("isDelete", isEqualTo: false)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self)})
    }
    
    private func addUserAndLocation(replies: [Colloquy], localUsers: [User]) async throws -> [Colloquy] {
        
        var addReplies = replies
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            var colloquyUser = localUsers.first(where: { $0.id == colloquy.ownerUid })
            if colloquyUser == nil {
                colloquyUser = try await userService.fetchUser(withUid: colloquy.ownerUid)
            }
            
            addReplies[i].user = colloquyUser
            
            guard let locationId = colloquy.locationId else { continue }
            let colloquyLocation = try await fetchLocation.fetchLocation(withId: locationId)
            
            addReplies[i].location = colloquyLocation
        }
        
        return addReplies
        
    }
    
    func reload() async {
        
        self.lastDocument = nil
        self.isDataLoaded = false
        
        self.lastDocumentColloquy = nil
        self.isDataLoadedColloquy = false
        
    }
}
