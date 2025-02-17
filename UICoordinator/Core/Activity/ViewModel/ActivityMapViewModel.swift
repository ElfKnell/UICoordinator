//
//  ActivityMapViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/07/2024.
//

import Foundation
import MapKit
import SwiftUI
import Firebase

class ActivityMapViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var searchLoc = [Location]()
    @Published var selectedPlace: Location?
    @Published var searctText = ""
    @Published var isMark = false
    @Published var isSettings = false
    @Published var isSave = false
    
    @Published var coordinate: CLLocationCoordinate2D = .startLocation
    @Published var sheetConfig: MapSheetConfig?
    
    @Published var getDirections = false
    
    @MainActor
    func getResults(_ cameraPosition: MapCameraPosition, searchText: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let results = await MapSearchViewModel.serchPlace(region: cameraPosition.region, searchText: searchText)
        
        
        for result in results {
            let loc: Location = .init(ownerUid: uid, name: result.placemark.name ?? "no name", description: "", address: result.placemark.title, timestamp: Timestamp(), latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude, isSearch: true, activityId: nil)
            
            searchLoc.append(loc)
        }
    }
    
    @MainActor
    func clean() {
        searchLoc = []
    }
    
    @MainActor
    func getLocations(activityId: String) async throws {
        self.locations = try await LocationService.fetchActivityLocations(activityId: activityId)
    }
    
    func saveRegione(_ region: MKCoordinateRegion?, activityId: String) async throws {
        
        guard let region = region else { return }

        try await ActivityService.updateActivityCoordinate(region: region, id: activityId)
    }
    
    func saveLocations(activityId: String) async throws {
        var locationId = [String]()
        for location in self.locations {
            locationId.append(location.id)
        }
        
        try await ActivityService.updateActivityLocations(locationsId: locationId, id: activityId)
    }
    
    func infoView() {
        if sheetConfig == .confirmationLocation {
            sheetConfig = nil
        } else {
            sheetConfig = .confirmationLocation
        }
    }
}
