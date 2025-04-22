//
//  FetchRepliesFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FetchRepliesFirebase: FetchRepliesProtocol {
    
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var fetchLocation = FetchLocationFromFirebase()
    private var lastDocumentColloquy: DocumentSnapshot?
    private var isDataLoadedColloquy = false
    private var userService = UserService()
    
    func getReplies(userId: String, localUsers: [User], pageSize: Int) async -> [Colloquy] {
        
        do {
            
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
            
            var replies = snapshot.documents.compactMap { document in
                let colloquy = try? document.data(as: Colloquy.self)
                
                if colloquy?.ownerColloquy == nil {
                    return colloquy
                } else {
                    return nil
                }
            }
            
            replies = await addUserAndLocation(replies: replies, localUsers: localUsers)
            
            return replies
            
        } catch {
            print("ERROR fetching replies: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func getReplies(colloquyId: String, localUsers: [User], pageSize: Int) async -> [Colloquy] {
        
        do {
            
            if isDataLoadedColloquy { return [] }
            
            var query = Firestore
                .firestore()
                .collection("colloquies")
                .whereField("ownerColloquy", isEqualTo: colloquyId)
                .order(by: "timestamp", descending: true)
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
            
            replies = await addUserAndLocation(replies: replies, localUsers: localUsers)
            
            return replies
            
        } catch {
            print("ERROR fetching replies: \(error.localizedDescription)")
            return []
        }
    }
    
    private func addUserAndLocation(replies: [Colloquy], localUsers: [User]) async -> [Colloquy] {
        
        var addReplies = replies
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            var colloquyUser = localUsers.first(where: { $0.id == colloquy.ownerUid })
            if colloquyUser == nil {
                colloquyUser = await userService.fetchUser(withUid: colloquy.ownerUid)
            }
            
            addReplies[i].user = colloquyUser
            
            guard let locationId = colloquy.locationId else { continue }
            let colloquyLocation = await fetchLocation.fetchLocation(withId: locationId)
            
            addReplies[i].location = colloquyLocation
        }
        
        return addReplies
    }
}
