//
//  EditLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import MapKit
import Firebase

class EditLocationViewModel: ObservableObject {
    
    func updateLocation(_ location: Location) async throws {
        guard let locationId = location.locationId else { return }
        try await LocationService.updateLocation(location, locationId: locationId)
    }
    
}
