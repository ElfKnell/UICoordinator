//
//  FetchColloquies.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class FetchColloquiesFirebase: FetchColloquiesProtocol {
    
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var lastDocumentForUser: DocumentSnapshot?
    private var isUserDataLoaded = false
    private var fetchLocation = FetchLocationFromFirebase()
    
    func getColloquies(users: [User], pageSize: Int) async -> [Colloquy] {
        
        do {
            if isDataLoaded { return [] }
            
            var query = Firestore
                .firestore()
                .collection("colloquies")
                .order(by: "timestamp", descending: true)
                .limit(to: pageSize)
            
            if !users.isEmpty {
                let usersId = users.map({ $0.id })
                query = query.whereField("ownerUid", in: usersId)
            }
            
            if let lastDoc = lastDocument {
                query = query.start(afterDocument: lastDoc)
            }
            
            let snapshot = try await query.getDocuments()
            
            if snapshot.documents.isEmpty {
                isDataLoaded = true  // Set flag to true if no data is returned
                return []
            }
            
            self.lastDocument = snapshot.documents.last
            
            var colloquies = snapshot.documents.compactMap { document in
                let colloquy = try? document.data(as: Colloquy.self)
                
                if colloquy?.ownerColloquy == nil {
                    return colloquy
                } else {
                    return nil
                }
            }
            
            for i in 0 ..< colloquies.count
            {
                let colloquy = colloquies[i]
                let colloquyUser = users.first(where: { $0.id == colloquy.ownerUid })
                
                colloquies[i].user = colloquyUser
                
                guard let locationId = colloquy.locationId else { continue }
                let colloquyLocation = await fetchLocation.fetchLocation(withId: locationId)
                colloquies[i].location = colloquyLocation
            }
            
            return colloquies
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return []
        }
    }
    
    func getUserColloquies(user: User, pageSize: Int) async -> [Colloquy] {
        
        do {
            if isUserDataLoaded { return [] }
            
            var query = Firestore
                .firestore()
                .collection("colloquies")
                .whereField("ownerUid", isEqualTo: user.id)
                .order(by: "timestamp", descending: true)
                .limit(to: pageSize)
            
            if let lastDoc = lastDocumentForUser {
                query = query.start(afterDocument: lastDoc)
            }
            
            let snapshot = try await query.getDocuments()
            
            if snapshot.documents.isEmpty {
                isUserDataLoaded = true  // Set flag to true if no data is returned
                return []
            }
            
            self.lastDocumentForUser = snapshot.documents.last
            
            var colloquies = snapshot.documents.compactMap { document in
                let colloquy = try? document.data(as: Colloquy.self)
                
                if colloquy?.ownerColloquy == nil {
                    return colloquy
                } else {
                    return nil
                }
            }
            
            for i in 0 ..< colloquies.count
            {
                let colloquy = colloquies[i]
                
                colloquies[i].user = user
                
                guard let locationId = colloquy.locationId else { continue }
                let colloquyLocation = await fetchLocation.fetchLocation(withId: locationId)
                colloquies[i].location = colloquyLocation
            }
            
            return colloquies
        } catch {
            print("Fetch for user failed: \(error.localizedDescription)")
            return []
        }
    }
}
