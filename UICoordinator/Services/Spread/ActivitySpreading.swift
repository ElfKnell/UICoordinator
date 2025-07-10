//
//  ActivitySpreading.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Firebase
import Foundation

class ActivitySpreading: SpreadingActivityProtocol {
    
    private let nameCollection = "Spread"
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var userServise: UserServiceProtocol
    private let fetchingActivity: FetchingActivityProtocol
    
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate(),
         userServise: UserServiceProtocol,
         fetchingActivity: FetchingActivityProtocol) {
        self.serviceCreate = serviceCreate
        self.userServise = userServise
        self.fetchingActivity = fetchingActivity
    }
    
    func createSpread(_ spreadActivity: Spread) async {
        
        do {
            guard let spreadData = try? Firestore.Encoder()
                .encode(spreadActivity) else { throw FollowError.encodingFailed }
            
            try await self.serviceCreate.addDocument(from: nameCollection, data: spreadData)
            
        } catch {
            print("ERROR CREATE SPREAD: \(error.localizedDescription)")
        }
    }
    
    func getSpreads(users: [User], pageSize: Int, byField: String) async -> [Spread] {
        do {
            if isDataLoaded { return [] }
            if users.isEmpty { return [] }
            let usersId = users.map({ $0.id })
            
            var query = Firestore
                .firestore()
                .collection("Spread")
                .whereField("ownerUid", in: usersId)
                .whereField(byField, isNotEqualTo: "")
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
            
            var spreads = snapshot.documents.compactMap({ try? $0.data(as: Spread.self)})
            
            for i in 0 ..< spreads.count
            {
                let activityId = spreads[i].activityId
                let userId = spreads[i].userId
                
                let activity = await fetchingActivity.fetchActivity(documentId: activityId)
                spreads[i].activity = activity
                
                let ownerUser = users.first(where: { $0.id == spreads[i].ownerUid })
                spreads[i].ownerUser = ownerUser
                
                let user = try await userServise.fetchUser(withUid: userId)
                spreads[i].user = user
            }
            
            return spreads
            
        } catch {
            print("ERROR FETCHING SPREAD: \(error.localizedDescription)")
            return []
        }
    }
    
    func clean() {
        self.lastDocument = nil
        self.isDataLoaded = false
    }
}
