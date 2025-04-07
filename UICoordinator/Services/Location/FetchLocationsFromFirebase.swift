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
    
    func getLocations(userId: String, pageSize: Int) async throws -> [Location] {
        
        if isDataLoaded { return [] }
        var query = Firestore
            .firestore()
            .collection("locations")
            .whereField("ownerUid", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .limit(to: pageSize)
            
        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isDataLoaded = true  // Set flag to true if no data is returned
            return []
        }
        
        self.lastDocument = snapshot.documents.last
        
        return snapshot.documents.compactMap { document in
            let location = try? document.data(as: Location.self)
            
            if location?.activityId == nil {
                return location
            } else {
                return nil
            }
        }
    }
    
    
    
}
