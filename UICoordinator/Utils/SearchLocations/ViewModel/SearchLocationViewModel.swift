//
//  SearchLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/04/2025.
//

import MapKit
import SwiftUI
import Firebase

class SearchLocationViewModel: ObservableObject {
    
    @Published var searctText: String = ""
    
    let currentUser = UserService.shared.currentUser
    
    func getLocations(_ cameraPosition: MapCameraPosition) async -> [Location] {
        
        var searchLocations: [Location] = []
        guard let uid = currentUser?.id else { return [] }
        let results = await serchPlace(region: cameraPosition.region, searchText: self.searctText)
        
        for result in results {
            let location: Location = .init(ownerUid: uid, name: result.placemark.name ?? "no name", description: "", address: result.placemark.title, timestamp: Timestamp(), latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude, isSearch: true, activityId: nil)
            
            searchLocations.append(location)
        }
        
        return searchLocations
    }

    private func serchPlace(region: MKCoordinateRegion?, searchText: String) async -> [MKMapItem] {
        
        guard let region = region else { return [] }
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let result = try? await MKLocalSearch(request: request).start()
        return result?.mapItems ?? []
    }
}
