//
//  MapSearchViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import MapKit
import SwiftUI

@MainActor
class MapSearchViewModel: ObservableObject {

    let currentUser = UserService.shared.currentUser
    
    static func serchPlace(region: MKCoordinateRegion?, searchText: String) async -> [MKMapItem] {
        guard let region = region else {
            return []
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let result = try? await MKLocalSearch(request: request).start()
        return result?.mapItems ?? []
    }

    func openMap(mapSeliction: Location?) {
        if let mapSeliction {
            let mapToOpen: MKMapItem = .init(placemark: .init(coordinate: mapSeliction.coordinate))
            mapToOpen.openInMaps()
        }
    }
}
