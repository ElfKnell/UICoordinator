//
//  FetchLocationsForActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import Firebase
import FirebaseFirestoreSwift

class FetchLocationsForActivity: FetchLocationsForActivityProtocol {
    
    let firebase = Firestore.firestore()
    
    func getLocations(activityId: String) async -> [Location] {
        
        do {
            
            let snapshot = try await firebase
                .collection("locations")
                .whereField("activityId", isEqualTo: activityId)
                .getDocuments()
            
            let locations = snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
            return locations.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            
        } catch {
            print("ERROR - problem with fetching locations for activity. \(error)")
            return []
        }
        
    }
}
