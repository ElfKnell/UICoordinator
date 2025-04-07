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
    
    func uploadLocation(_ location: Location) async {
    
        do {
            
            guard let locationData = try? Firestore.Encoder().encode(location) else { return }
            try await firebase.collection("locations").addDocument(data: locationData)
            
        } catch {
            print("ERROR save location: \(error.localizedDescription)")
        }
    
    }
    
    func updateNameAndDescriptionLocation(name: String, description: String, locationId: String) async {
        
        do {
            try await firebase
                .collection("locations")
                .document(locationId)
                .updateData(["description": description, "name": name, "timeUpdate": Timestamp()])

        } catch {
            print("ERROR update location: \(error.localizedDescription)")
        }
    }
    
    func updateAddressLocation(address: String, locationId: String) async {
        
        do {
            try await firebase
                .collection("locations")
                .document(locationId)
                .updateData(["address": address])

        } catch {
            print("ERROR update address location: \(error.localizedDescription)")
        }
    }
    
}
