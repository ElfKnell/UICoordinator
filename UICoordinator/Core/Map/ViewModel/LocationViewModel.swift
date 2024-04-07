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
    @Published var mapSelection: MKMapItem?
    @Published var routeDistination: MKMapItem?
    @Published var route: MKRoute?
    @Published var results = [MKMapItem]()
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
        self.locations = try await LocationService.fetchUserLocations(uid: userUid)
        try await getCameraPosition()
    }
    
    private func getCameraPosition() async throws {
        if !locations.isEmpty {
            if let coordinatePosition = coordinatePosition {
                self.cameraPosition = .region(.init(center: coordinatePosition, latitudinalMeters: 1000, longitudinalMeters: 1000))
                self.coordinateRouter = coordinatePosition
                
            } else {
                self.cameraPosition = .region(locations[0].regionCoordinate)
                self.coordinateRouter = locations[0].coordinate
            }
        } else {
            self.cameraPosition = .region(.startRegion)
        }
    }
    
    func getResults() async throws {
        try await getCameraPosition()
        self.results = await MapSearchViewModel.serchPlace(region: cameraPosition.region, searchText: searchText)
    }
    
    func clean() {
        searchText = ""
        results = []
        mapSelection = nil
        getDirections = false
        routeDistination = nil
        route = nil
        routeDisplaying = false
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: coordinateRouter))
            request.destination = mapSelection
            
            Task {
                let result = try await MKDirections(request: request).calculate()
                route = result.routes.first
                routeDistination = mapSelection
                
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
