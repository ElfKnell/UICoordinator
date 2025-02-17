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
    
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    
    @MainActor
    func uploadLocation(coordinate: CLLocationCoordinate2D, activityId: String?) async throws {
        var corectAddress: String?
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        if self.address != "" {
            corectAddress = address
        }
        
        let location = Location(ownerUid: userUid, name: self.name, description: self.description, address: corectAddress, timestamp: Timestamp(), latitude: coordinate.latitude, longitude: coordinate.longitude, activityId: activityId)
        
        try await LocationService.uploadLocation(location)
    }
}
