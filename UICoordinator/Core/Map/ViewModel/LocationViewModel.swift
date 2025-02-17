//
//  LocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import Firebase
import MapKit
import SwiftUI

@MainActor
class LocationViewModel: ObservableObject {
    @Published var locations = [Location]()
    @Published var coordinate: CLLocationCoordinate2D = .startLocation
    @Published var coordinatePosition: CLLocationCoordinate2D?
    @Published var cameraPosition: MapCameraPosition = .region(.startRegion)
    
    @Published var searchText = ""
    @Published var mapSelection: Location?
    @Published var routeDistination: MKMapItem?
    @Published var route: MKRoute?
    @Published var searchLoc = [Location]()
    @Published var routeDisplaying = false
    @Published var getDirections = false
    
    @Published var sheetConfig: MapSheetConfig?
    @Published var coordinateRouter: CLLocationCoordinate2D = .startLocation
    
    init() {
        Task {
            try await fetchUserForLocations()
        }
    }
    
    func fetchUserForLocations() async throws {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let loc_s = try await LocationService.fetchUserLocations(uid: userUid)
        self.locations = loc_s.filter({ $0.activityId == nil })
        try await getCameraPosition()
    }
    
    private func getCameraPosition() async throws {
        if !locations.isEmpty {
            if let coordinatePosition = coordinatePosition {
                self.cameraPosition = .region(.init(center: coordinatePosition, latitudinalMeters: 500, longitudinalMeters: 500))
                self.coordinateRouter = coordinatePosition
                
            } else {
                self.cameraPosition = .region(locations[0].regionCoordinate)
                self.coordinateRouter = locations[0].coordinate
            }
        } else {
            self.cameraPosition = .region(.startRegion)
        }
    }
    
    func getResults(_ cameraPosition: MapCameraPosition) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let results = await MapSearchViewModel.serchPlace(region: cameraPosition.region, searchText: searchText)
        
        for result in results {
            let loc: Location = .init(ownerUid: uid, name: result.placemark.name ?? "no name", description: "", address: result.placemark.title, timestamp: Timestamp(), latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude, isSearch: true, activityId: nil)
            
            searchLoc.append(loc)
        }
    }
    
    func clean() {
        searchText = ""
        searchLoc = []
        mapSelection = nil
        getDirections = false
        routeDistination = nil
        route = nil
        routeDisplaying = false
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            let mapItem: MKMapItem = .init(placemark: .init(coordinate: mapSelection.coordinate))
            request.source = MKMapItem(placemark: .init(coordinate: coordinateRouter))
            request.destination = mapItem
            
            Task {
                let result = try await MKDirections(request: request).calculate()
                route = result.routes.first
                routeDistination = mapItem
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    sheetConfig = nil
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}
