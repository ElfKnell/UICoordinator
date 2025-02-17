//
//  ActivityRoutesViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/10/2024.
//

import MapKit
import SwiftUI
import Firebase

class ActivityRoutesViewModel: ObservableObject {
    
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
    
    @Published var routes: [MKRoute] = []
    
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
    func getLocations(activityId: String) async throws -> [Location] {
        return try await LocationService.fetchActivityLocations(activityId: activityId)
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
    func getRoutes(aId: String, first: Bool) async throws {

        var sortedLoc: [Location]
        let locations = try await getLocations(activityId: aId)
        if locations.isEmpty { return }
        self.locations = locations
        if first {
            sortedLoc = locations.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        } else {
            sortedLoc = locations.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
        let location = sortedLoc[0]
        let loc = sortedLoc.filter { $0 != location }
        try await getMinRouters(locations: loc, startPoint: location)

    }
    
    func getDirections(startingPoint: Location, endPoint: Location) async throws -> MKRoute? {
            
            // Create and configure the request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingPoint.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint.coordinate))
            
            // Get the directions based on the request
        let directions = MKDirections(request: request)
        let response = try? await directions.calculate()
        return response?.routes.first

    }
    
    @MainActor
    func getMinRouters(locations: [Location], startPoint: Location) async throws {
        if locations.isEmpty {
            try await getLastRouter(startPoint: startPoint)
            return
        }
        guard var routeMin: MKRoute = try await getDirections(startingPoint: startPoint, endPoint: locations[0]) else { return }
        var sPoint = startPoint
        
        for i in 0 ..< locations.count {
            if let route = try await getDirections(startingPoint: startPoint, endPoint: locations[i]) {
                if route.expectedTravelTime <= routeMin.expectedTravelTime {
                    routeMin = route
                    sPoint = locations[i]
                }
            }
        }
        self.routes.append(routeMin)
        let locations = locations.filter { $0 != sPoint }
        try await getMinRouters(locations: locations, startPoint: sPoint)
    }
    
    @MainActor
    func getLastRouter(startPoint: Location) async throws {
        guard let route: MKRoute = try await getDirections(startingPoint: startPoint, endPoint: locations[0]) else { return }
        
        self.routes.append(route)
    }
}

