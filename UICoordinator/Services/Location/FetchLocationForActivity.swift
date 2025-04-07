//
//  FetchLocationForActivity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import MapKit
import Firebase
import FirebaseFirestoreSwift


class FetchLocationForActivity: FetchLocationForActivityProtocol {
    
    let firebase = Firestore.firestore()
    
    func getLocation(coordinate: CLLocationCoordinate2D, activityId: String) -> Location? {
        
        var location: Location?
        
        Task {
            location = await fetchAsyncLocation(coordinate: coordinate, activityId: activityId)
        }
        
        return location
    }
    
    private func fetchAsyncLocation(coordinate: CLLocationCoordinate2D, activityId: String) async -> Location? {
        
        do {
            
            let snapshot = try await firebase
                .collection("locations")
                .whereField("activityId", isEqualTo: activityId)
                .whereField("latitude", isEqualTo: coordinate.latitude)
                .whereField("longitude", isEqualTo: coordinate.longitude)
                .getDocuments()
            
            let locations = snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
            if locations.isEmpty { return nil }
            return locations[0]
            
        } catch {
            print("ERROR - problem with fetching location for activity. \(error)")
            return nil
        }
    }
}
