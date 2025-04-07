//
//  EditLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import MapKit
import Firebase

class EditLocationViewModel: ObservableObject {
    
    private var serviseLocation = LocationService()
    
    func updateLocation(_ location: Location) async {
        
        guard let locationId = location.locationId else { return }
        await serviseLocation.updateNameAndDescriptionLocation(name: location.name, description: location.description, locationId: locationId)
    }
    
}
