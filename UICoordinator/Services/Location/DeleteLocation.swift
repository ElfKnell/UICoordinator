//
//  DeleteLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/04/2025.
//

import Firebase
import FirebaseFirestoreSwift

class DeleteLocation: DeleteLocationProtocol {
    
    func deleteLocation(at locationId: String) async {
        
        do {
            try await Firestore
                .firestore()
                .collection("locations")
                .document(locationId)
                .delete()
        } catch {
            print("ERROR delete location: \(error.localizedDescription)")
        }
    }
    
    func deleteLocations(with locationsId: [String]) async {
        
        if locationsId.isEmpty { return }
        
        for id in locationsId {
            await deleteLocation(at: id)
        }
    }
}
