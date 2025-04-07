//
//  UserLocationsViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/04/2025.
//

import Firebase
import MapKit
import SwiftUI

@MainActor
class UserLocationsViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var cameraPosition: MapCameraPosition = .region(.startRegion)
    
    @Published var mapSelection: Location?
    @Published var searchLoc = [Location]()
    
    @Published var isSelected = false
    @Published var showSearch = false
    @Published var getDirections = false
    @Published var sheetConfig: MapSheetConfig?
    
    private var fetchLocations = FetchLocations()
    
    @AppStorage("styleMap") var styleMap: ActivityMapStyle = .standard
    
    func fetchUserForLocations(userId: String) async throws {
        
        do {
            
            fetchLocations = FetchLocations()
            locations.removeAll()
            
            self.locations = await fetchLocations.fetchLocation(userId)
            
            try await getCameraPosition()
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func fetchMoreLocationsByCurentUser(userId: String) {
        Task {
            self.locations.append(contentsOf: await fetchLocations.fetchLocation(userId))
        }
    }
    
    private func getCameraPosition() async throws {
        if !locations.isEmpty {
            self.cameraPosition = .region(locations[0].regionCoordinate)
        }
    }
}
