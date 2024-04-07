//
//  LocationService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import Firebase
import FirebaseFirestoreSwift

struct LocationService {
    
    static func uploadLocation(_ location: Location) async throws {
        guard let locationData = try? Firestore.Encoder().encode(location) else { return }
        try await Firestore.firestore().collection("locations").addDocument(data: locationData)
    
    }
    
    static func fetchUserLocations(uid: String) async throws -> [Location] {
        let snapshot = try await Firestore
            .firestore()
            .collection("locations")
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        let locations = snapshot.documents.compactMap({ try? $0.data(as: Location.self)})
        return locations.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
    
    static func updateLocation(_ location: Location, locationId: String) async throws {
        
        do {
            try await Firestore.firestore()
                .collection("locations")
                .document(locationId)
                .updateData(["description": location.description, "name": location.name, "timeUpdate": Timestamp()])

        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func fetchLocation(withLid lid: String) async throws -> Location {
        let snapshot = try await Firestore.firestore().collection("locations").document(lid).getDocument()
        return try snapshot.data(as: Location.self)
    }
}
