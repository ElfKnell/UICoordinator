//
//  UserLocationsViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/04/2025.
//

import Firebase
import MapKit
import SwiftUI

class UserLocationsViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var cameraPosition: MapCameraPosition = .region(.startRegion)
    
    @Published var mapSelection: Location?
    @Published var searchLoc = [Location]()
    
    @Published var isSelected = false
    @Published var showSearch = false
    @Published var getDirections = false
    @Published var sheetConfig: MapSheetConfig?
    
    @Published var userId: String
    private let fetchLocationsService: FetchLocationsProtocol
    private let pageSize = 25
    
    @AppStorage("styleMap") var styleMap: UserMapStyle = .standard
    
    init(userId: String, fetchLocationsService: FetchLocationsProtocol) {
        self.userId = userId
        self.fetchLocationsService = fetchLocationsService
        Task {
            await fetchUserForLocations()
        }
    }
    
    @MainActor
    func fetchUserForLocations() async {
        
        let fetchLocationsList = await fetchLocations()
        self.locations = fetchLocationsList
        getCameraPosition()
    }
    
    @MainActor
    func fetchMoreLocationsByCurentUser() {
        Task {
            let moreLocations = await fetchLocations()
            
            self.locations.append(contentsOf: moreLocations)
            
        }
    }
    
    @MainActor
    private func getCameraPosition() {
        
        if !locations.isEmpty {
            self.cameraPosition = .region(locations[0].regionCoordinate)
        } else {
            self.cameraPosition = .automatic
        }
    }
    
    private func fetchLocations() async -> [Location] {
        
        let locations = await fetchLocationsService.getLocations(userId: self.userId, pageSize: pageSize)

        return locations
    }
}
