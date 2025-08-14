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
    
    @Published var customAnnotation: MKPointAnnotation?
    
    @Published var getDirections = false
    
    @Published var routes: [MKRoute] = []
    
    private let fetchLocatins: FetchLocationsForActivityProtocol
    private let activityUpdate: ActivityUpdateProtocol
    
    init(fetchLocatins: FetchLocationsForActivityProtocol, activityUpdate: ActivityUpdateProtocol) {
       
        self.fetchLocatins = fetchLocatins
        self.activityUpdate = activityUpdate
    }
    
    @MainActor
    func clean() {
        searchLocations.removeAll()
    }
    
    func initialCamera(for activity: Activity) -> MapCameraPosition {
        if let region = activity.region {
            return .region(region)
        } else {
            return .userLocation(fallback: .automatic)
        }
    }
    
    func saveRegione(_ region: MKCoordinateRegion?, activityId: String) async throws {
        
        guard let region = region else { return }

        try await activityUpdate.updateActivityCoordinate(region: region, id: activityId)
    }
    
    func saveLocations(activityId: String) async throws {
        var locationId = [String]()
        for location in self.locations {
            locationId.append(location.id)
        }
        
        await activityUpdate.updateActivityLocations(locationsId: locationId, id: activityId)
    }
    
    func infoView() {
        if sheetConfig == .confirmationLocation {
            sheetConfig = nil
        } else {
            sheetConfig = .confirmationLocation
        }
    }
    
    @MainActor
    func getRoutes(activity: Activity) async {

        do {
            if activity.typeActivity == .track {
                let locations = await fetchLocatins.getLocations(activityId: activity.id)
                self.locations = locations
                let activityRouter = ActivityRouters()
                self.routes = try await activityRouter.getRoutes(locations: locations)
            } else {
                self.locations = await fetchLocatins.getLocations(activityId: activity.id)
            }
        } catch {
            print("ERROR GET ROUTES: \(error.localizedDescription)")
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

