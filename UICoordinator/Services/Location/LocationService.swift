//
//  LocationService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import Firebase
import FirebaseFirestoreSwift

class LocationService: SaveLocationProtocol, UpdateLocationProtocol {
    
    private var firebase = Firestore.firestore()
    
    func uploadLocation(_ location: Location) async throws {
    
        let locationData = try Firestore.Encoder().encode(location)
        
        try await firebase.collection("locations").addDocument(data: locationData)
    
    }
    
    func updateNameAndDescriptionLocation(
        name: String,
        description: String,
        locationId: String) async throws {
        
        try await firebase
            .collection("locations")
            .document(locationId)
            .updateData(["description": description, "name": name, "timeUpdate": Timestamp()])
        
    }
    
    func updateAddressLocation(address: String, locationId: String) async throws {
        
        try await firebase
            .collection("locations")
            .document(locationId)
            .updateData(["address": address])
        
    }
}
