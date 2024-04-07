//
//  ConfirmationLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import Foundation
import Firebase
import MapKit

class ConfirmationLocationViewModel: ObservableObject {
    
    @MainActor
    func uploadLocation(name: String, description: String, coordinate: CLLocationCoordinate2D) async throws {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let location = Location(ownerUid: userUid, name: name, description: description, timestamp: Timestamp(), latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        try await LocationService.uploadLocation(location)
    }
}
