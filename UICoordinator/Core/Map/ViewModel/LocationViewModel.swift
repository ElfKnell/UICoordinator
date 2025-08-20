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
    @Published var navigatedLocation: Location?
    @Published var route: MKRoute?
    
    @Published var getDirections = false
    @Published var sheetConfig: MapSheetConfig? = nil
    
    @Published var customAnnotation: MKPointAnnotation?

    @Published var showSearch = false
    @Published var isSave = false
    
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
    func addLocation(userId: String?) {
        
        guard let userId = userId else { return }
        guard let coordinate = customAnnotation?.coordinate else { return }
        
        Task {
            
            let location = await locationService.getLocation(
                userId: userId,
                coordinate: coordinate
            )
            
            if let location = location {
                
                if !locations.contains(where: {
                    $0.id == location.id
                }) {
                    locations.append(location)
                }
                cameraPosition = .region(location.regionCoordinate)
            }
            
            customAnnotation = nil
        }
    }
    
    @MainActor
    func updateOrDeleteLocation(userId: String?) {
        
        guard let userId = userId else { return }
        guard let mapSelection = mapSelection else { return }
        
        Task {
            
            switch await locationService.getLocation(
                userId: userId,
                coordinate: mapSelection.coordinate
            ) {
                
            case let location?:
                if let index = locations.firstIndex(where: {
                    $0.id == location.id
                }) {
                    locations[index] = location
                }
                cameraPosition = .region(location.regionCoordinate)
                
            case nil:
                if let index = locations.firstIndex(where: {
                    $0.id == mapSelection.id
                }) {
                    locations.remove(at: index)
                }
            }
            
            self.mapSelection = nil
            
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
    
    @MainActor
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
        
        let locationVerifyId = locations.firstIndex(where: {
            $0.id == selectedLocation.id
        })
        
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
    
    func handleTap(on coordinate: CLLocationCoordinate2D) {
        
        guard mapSelection == nil && sheetConfig == nil else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New Location"
        customAnnotation = annotation
        sheetConfig = .confirmationLocation
    }
    
    private func loadColor() {
        if let loadedColor = Color.loadFromAppStorage("routerColor") {
            routerColor = Color(red: loadedColor.red, green: loadedColor.green, blue: loadedColor.blue, opacity: loadedColor.alpha)
        }
    }
}
