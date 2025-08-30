//
//  FetchLocationFromFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/04/2025.
//

import MapKit
import Firebase
import FirebaseFirestoreSwift

class FetchLocationFromFirebase: FetchLocationFormFirebaseProtocol {
    
    let firebase = Firestore.firestore()
    
    func getLocation(userId: String, coordinate: CLLocationCoordinate2D) async throws -> Location? {
        
        var location: Location?
        
        location = try await getAsyncLocation(userId: userId, coordinate: coordinate)
        
        return location
    }
    
    func fetchLocation(withId id: String) async throws -> Location {
        
        let snapshot = try await firebase
            .collection("locations")
            .document(id)
            .getDocument()
        
        return try snapshot.data(as: Location.self)
        
    }
    
    private func getAsyncLocation(
        userId: String,
        coordinate: CLLocationCoordinate2D
    ) async throws -> Location? {
        
        let snapshot = try await firebase
            .collection("locations")
            .whereField("ownerUid", isEqualTo: userId)
            .whereField("latitude", isEqualTo: coordinate.latitude)
            .whereField("longitude", isEqualTo: coordinate.longitude)
            .getDocuments()
        
        let locations = snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
        if locations.isEmpty { return nil }
        return locations[0]
        
    }
 
}
