//
//  ActivityRoutesViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/10/2024.
//

import MapKit
import SwiftUI
import Firebase

class ActivityEditViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var searchLocations = [Location]()
    @Published var selectedPlace: Location?
    @Published var searctText = ""
    @Published var isMark = false
    @Published var isSettings = false
    @Published var isSave = false
    @Published var isUpdate = false
    
    @Published var coordinate: CLLocationCoordinate2D = .startLocation
    @Published var sheetConfig: MapSheetConfig?
    
    @Published var getDirections = false
    
    @Published var routes: [MKRoute] = []
    
    private var fetchLocatins = FetchLocationsForActivity()
    
    @MainActor
    func clean() {
        searchLocations.removeAll()
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
    
    @MainActor
    func getRoutes(activity: Activity) async throws {

        if activity.typeActivity == .track {
            let locations = await fetchLocatins.getLocations(activityId: activity.id)
            self.locations = locations
            let activityRouter = ActivityRouters()
            self.routes = try await activityRouter.getRoutes(locations: locations)
        } else {
            self.locations = await fetchLocatins.getLocations(activityId: activity.id)
        }

    }
    
    func verifyLocation(selectedLocation: Location) -> Location {
        let locationVerifyId = locations.firstIndex(where: { $0.longitude == selectedLocation.longitude && $0.latitude == $0.latitude })
        if let id = locationVerifyId {
            return locations[id]
        } else {
            return selectedLocation
        }
    }
}

