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

}
