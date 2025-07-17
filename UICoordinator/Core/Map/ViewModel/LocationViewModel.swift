//
//  LocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import Firebase
import MapKit
import SwiftUI

class LocationViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var searchLoc = [Location]()
    
    @Published var coordinate: CLLocationCoordinate2D = .startLocation
    
    @Published var cameraPosition: MapCameraPosition = .region(.startRegion)
    
    @Published var mapSelection: Location?
    @Published var route: MKRoute?
    
    @Published var getDirections = false
    @Published var sheetConfig: MapSheetConfig? = nil
    
    @Published var isSave = false
    @Published var showSearch = false
    @Published var routerColor: Color = .blue
    
    var coordinatePosition: CLLocationCoordinate2D?
    
    private let locationService: FetchLocationFormFirebaseProtocol
    private let createRouter: CreateRouterProtocol
    private let fetchLocations: FetchLocations
    
    @AppStorage("styleMap") var styleMap: UserMapStyle = .standard
    
    init(locationService: FetchLocationFormFirebaseProtocol,
         createRouter: CreateRouterProtocol,
         fetchLocations: FetchLocations) {
        
        self.locationService = locationService
        self.createRouter = createRouter
        self.fetchLocations = fetchLocations
        
    }
    
    @MainActor
    func fetchLocationsByCurrentUser(userId: String?) async {
        
        if self.locations.isEmpty {
            
            self.locations = await fetchLocations.fetchLocations(userId)
            
            getCameraPosition()
            
            loadColor()
        }
        
    }
    
    @MainActor
    func fetchMoreLocationsByCurentUser(userId: String?) {
        
        Task {
            let fetchingLocation = await fetchLocations.fetchLocations(userId)
            if !fetchingLocation.isEmpty {
                self.locations.append(contentsOf: fetchingLocation)
            }
        }
    }
    
    @MainActor
    func addLocation(userId: String?) async {
        
        guard let userId = userId else { return }
        
        Task {
            
            let location = await locationService.getLocation(userId: userId, coordinate: coordinate)
            
            if let location = location {
                
                if locations.isEmpty {
                    locations.append(location)
                } else if !locations.contains(location) {
                    locations.append(location)
                }
                cameraPosition = .region(location.regionCoordinate)
            }
        }
    }
    
    private func getCameraPosition() {
        
        if !locations.isEmpty {
            
            if let coordinatePosition = coordinatePosition {
                
                self.cameraPosition = .region(.init(center: coordinatePosition, latitudinalMeters: 500, longitudinalMeters: 500))
                
            } else {
                
                self.cameraPosition = .region(locations[0].regionCoordinate)
                self.coordinatePosition = locations[0].coordinate
                
            }
            
        }
    }
    
    func clean() {
    
        self.mapSelection = nil
        self.getDirections = false
        self.route = nil
        
        getCameraPosition()
        
    }
    
    func fetchRoute() {
        
        Task {
            
            do {
                
                self.route = try await createRouter.getRouter(coordinate: self.coordinatePosition, mapSelection: self.mapSelection)
                
                withAnimation(.snappy) {
                    self.sheetConfig = nil
                    
                    if let rect = self.route?.polyline.boundingMapRect {
                        self.cameraPosition = .rect(rect)
                    }
                }
                
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func verifyLocation(selectedLocation: Location) -> Location {
        
        getDirections = false
        route = nil
        
        if sheetConfig == .locationUpdateOrSave { return selectedLocation }
        
        let locationVerifyId = locations.firstIndex(where: { $0.longitude == selectedLocation.longitude && $0.latitude == $0.latitude })
        
        sheetConfig = .locationsDetail
        
        if let id = locationVerifyId {
            return locations[id]
        } else {
            return selectedLocation
        }
        
    }
    
    func updateLocation(_ location: Location) {
        mapSelection = location
        sheetConfig = .locationUpdateOrSave
    }
    
    private func loadColor() {
        if let loadedColor = Color.loadFromAppStorage("routerColor") {
            routerColor = Color(red: loadedColor.red, green: loadedColor.green, blue: loadedColor.blue, opacity: loadedColor.alpha)
        }
    }
}
