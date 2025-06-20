//
//  MapSearchViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import MapKit
import SwiftUI

@MainActor
class LocationDetailViewModel: ObservableObject {

    private let fetchLocations: FetchLocationForActivityProtocol
    
    init(fetchLocations: FetchLocationForActivityProtocol) {
        self.fetchLocations = fetchLocations
    }

    func openMap(mapSeliction: Location?) {
        if let mapSeliction {
            let mapToOpen: MKMapItem = .init(placemark: .init(coordinate: mapSeliction.coordinate))
            mapToOpen.openInMaps()
        }
    }
    
    func isCurrentUserUpdateLocation(mapSeliction: Location?, activity: Activity?, currentUserId: String?) -> Bool {
        
        if  activity != nil && activity?.ownerUid != currentUserId {
            return false
        }
        return true
    }
}

