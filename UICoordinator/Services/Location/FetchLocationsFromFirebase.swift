//
//  GetUserLocationFromFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/04/2025.
//

import Firebase
import FirebaseFirestoreSwift

class FetchLocationsFromFirebase: FetchLocationsProtocol {
    
    private var isDataLoaded = false
    private var lastDocument: DocumentSnapshot?
    
    func getLocations(userId: String, pageSize: Int) async -> [Location] {
        
        do {
            
            if isDataLoaded { return [] }
            
            var query = Firestore
                .firestore()
                .collection("locations")
                .whereField("ownerUid", isEqualTo: userId)
                .whereField("activityId", isEqualTo: "")
                .order(by: "timestamp", descending: true)
                .limit(to: pageSize)
            
            if let lastDocument = lastDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
            if snapshot.documents.isEmpty {
                isDataLoaded = true
                return []
            }
            
            self.lastDocument = snapshot.documents.last
            
            return snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
                
        } catch {
            
            print("ERROR with fetching locations \(error.localizedDescription)")
            return []
            
        }
    }
}
