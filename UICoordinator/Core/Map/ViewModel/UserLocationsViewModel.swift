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
    
    @AppStorage("styleMap") var styleMap: UserMapStyle = .standard
    
    
    func fetchUserForLocations(userId: String) async {
        
        self.locations = await fetchLocations.fetchLocation(userId)
        
        getCameraPosition()

    }
    
    func fetchMoreLocationsByCurentUser(userId: String) {
        Task {
            self.locations.append(contentsOf: await fetchLocations.fetchLocation(userId))
        }
    }
    
    private func getCameraPosition() {
        
        if !locations.isEmpty {
            self.cameraPosition = .region(locations[0].regionCoordinate)
        }
    }
}
