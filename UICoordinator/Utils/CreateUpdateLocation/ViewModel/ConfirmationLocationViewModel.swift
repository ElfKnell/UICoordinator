//
//  ConfirmationLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import Foundation
import Firebase
import MapKit

class ConfirmationLocationViewModel: LocationService, ObservableObject {
    
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    
    @MainActor
    func uploadLocationWithCoordinate(coordinate: CLLocationCoordinate2D?,
                                      activityId: String?,
                                      annotation: MKPointAnnotation?,
                                      userUid: String?) async throws {
        
        var corectAddress: String?
        guard let userUid else { return }
        if self.address != "" {
            corectAddress = address
        }
        var newCoordinate: CLLocationCoordinate2D
        if let coordinate {
            newCoordinate = coordinate
        } else if let annotation {
            newCoordinate = annotation.coordinate
        } else {
            return
        }
        
        let location = Location(ownerUid: userUid, name: self.name, description: self.description, address: corectAddress, timestamp: Timestamp(), latitude: newCoordinate.latitude, longitude: newCoordinate.longitude, activityId: activityId ?? "")
        
        await uploadLocation(location)
    }
}
