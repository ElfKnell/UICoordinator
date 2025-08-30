//
//  DeleteLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import Firebase
import FirebaseFirestoreSwift

class DeleteLocation: DeleteLocationProtocol {
    
    func deleteLocation(at locationId: String) async throws {
        
        try await Firestore
            .firestore()
            .collection("locations")
            .document(locationId)
            .delete()
        
    }
    
    func deleteLocations(with locationsId: [String]) async throws {
        
        if locationsId.isEmpty { return }
        
        for id in locationsId {
            try await deleteLocation(at: id)
        }
    }
}
