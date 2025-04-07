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

    func openMap(mapSeliction: Location?) {
        if let mapSeliction {
            let mapToOpen: MKMapItem = .init(placemark: .init(coordinate: mapSeliction.coordinate))
            mapToOpen.openInMaps()
        }
    }
    
    func notSave(mapSeliction: Location?, activityId: String?) async throws -> Location? {
        guard let activityId = activityId else { return mapSeliction}
        if let mapSeliction {
            guard let location = try await LocationService.fetchActivityAndCoordinateLocations(location: mapSeliction, activityId: activityId) else { return mapSeliction }
            return location
        }
        return nil
    }
    
    func isCurrentUserUpdateLocation(mapSeliction: Location?, activity: Activity?) -> Bool {
        
        if  activity != nil && activity?.ownerUid != currentUser?.id {
            return false
        }
        return true
    }
}

