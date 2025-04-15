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
    
    func getReplies(userId: String, pageSize: Int) async -> [Colloquy] {
        
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
                isDataLoaded = true  // Set flag to true if no data is returned
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
            
            for i in 0 ..< replies.count
            {
                let colloquy = replies[i]
                let colloquyUser = await UserService.fetchUser(withUid: colloquy.ownerUid)
                
                replies[i].user = colloquyUser
                
                guard let locationId = colloquy.locationId else { continue }
                let colloquyLocation = await fetchLocation.fetchLocation(withId: locationId)
                
                replies[i].location = colloquyLocation
            }
            
            return replies
            
        } catch {
            print("ERROR fetching replies: \(error.localizedDescription)")
            return []
        }
        
    }
    
    
}
