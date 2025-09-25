//
//  FetchColloquies.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/04/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

actor FetchColloquiesFirebase: FetchColloquiesProtocol {
    
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var lastDocumentForUser: DocumentSnapshot?
    private var isUserDataLoaded = false
    
    private let fetchLocation: FetchLocationFormFirebaseProtocol
    
    init(fetchLocation: FetchLocationFormFirebaseProtocol) {
        self.fetchLocation = fetchLocation
    }
    
    func getColloquies(users: [User], pageSize: Int) async throws -> [Colloquy] {
        
        if isDataLoaded { return [] }
        
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerColloquy", isEqualTo: "")
            .whereField("isDelete", isEqualTo: false)
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
            isDataLoaded = true
            return []
        }
        
        self.lastDocument = snapshot.documents.last
        
        var colloquies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self) })
        
        for i in 0 ..< colloquies.count
        {
            let colloquy = colloquies[i]
            let colloquyUser = users.first(where: { $0.id == colloquy.ownerUid })
            
            colloquies[i].user = colloquyUser
            
            guard let locationId = colloquy.locationId else { continue }
            let colloquyLocation = try await fetchLocation.fetchLocation(withId: locationId)
            colloquies[i].location = colloquyLocation
        }
        
        return colloquies
        
    }
    
    func getUserColloquies(user: User, pageSize: Int) async throws -> [Colloquy] {
        
        if isUserDataLoaded { return [] }
        
        var query = Firestore
            .firestore()
            .collection("colloquies")
            .whereField("ownerUid", isEqualTo: user.id)
            .whereField("ownerColloquy", isEqualTo: "")
            .whereField("isDelete", isEqualTo: false)
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
        
        if let lastDoc = lastDocumentForUser {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isUserDataLoaded = true
            return []
        }
        
        self.lastDocumentForUser = snapshot.documents.last
        
        var colloquies = snapshot.documents.compactMap({ try? $0.data(as: Colloquy.self) })
        
        for i in 0 ..< colloquies.count
        {
            let colloquy = colloquies[i]
            
            colloquies[i].user = user
            
            guard let locationId = colloquy.locationId else { continue }
            let colloquyLocation = try await fetchLocation.fetchLocation(withId: locationId)
            colloquies[i].location = colloquyLocation
        }
        
        return colloquies
        
    }
    
    func reload() async {
        
        self.lastDocument = nil
        self.isDataLoaded = false
        self.lastDocumentForUser = nil
        self.isUserDataLoaded = false

    }
}
