//
//  SearchLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/04/2025.
//

import MapKit
import SwiftUI
import FirebaseCrashlytics

class SearchLocationViewModel: ObservableObject {
    
    @Published var searctText: String = ""
    
    func getLocations(_ cameraPosition: MapCameraPosition) async -> [Location] {
        
        var searchLocations: [Location] = []
        let results = await serchPlace(region: cameraPosition.region, searchText: self.searctText)
        
        for result in results {
            let location = Location(
                name: result.placemark.name ?? "no name",
                description: result.placemark.description
                    .replacingOccurrences(of: "\\s*@.*", with: "", options: .regularExpression),
                address: result.placemark.title,
                latitude: result.placemark.coordinate.latitude,
                longitude: result.placemark.coordinate.longitude,
                isSearch: true)
            
            searchLocations.append(location)
        }
        
        return searchLocations
    }

    private func serchPlace(region: MKCoordinateRegion?, searchText: String) async -> [MKMapItem] {
        
        guard let region = region else {
            Crashlytics.crashlytics().log("Search failed: region is nil")
            return []
        }
        
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = searchText
        request.region = region
        
        do {
            
            let result = try await MKLocalSearch(request: request).start()
            return result.mapItems
            
        } catch {
            Crashlytics.crashlytics().record(error: error)
            Crashlytics.crashlytics().log("Search failed for text: \(searchText)")
            return []
        }
    }
}
