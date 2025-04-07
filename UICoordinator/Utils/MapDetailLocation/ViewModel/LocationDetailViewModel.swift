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

    let currentUser = UserService.shared.currentUser
    private let fetchLocations = FetchLocationForActivity()

    func openMap(mapSeliction: Location?) {
        if let mapSeliction {
            let mapToOpen: MKMapItem = .init(placemark: .init(coordinate: mapSeliction.coordinate))
            mapToOpen.openInMaps()
        }
    }
    
    func isCurrentUserUpdateLocation(mapSeliction: Location?, activity: Activity?) -> Bool {
        
        if  activity != nil && activity?.ownerUid != currentUser?.id {
            return false
        }
        return true
    }
}

