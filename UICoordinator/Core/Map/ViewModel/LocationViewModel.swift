//
//  LocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import Firebase
import MapKit
import SwiftUI
import FirebaseCrashlytics

class LocationViewModel: ObservableObject {
    
    private let pageSize = 20
    
    var coordinatePosition: CLLocationCoordinate2D?
    
    @Published var locations = [Location]()
    @Published var searchLoc = [Location]()
    
    @Published var coordinate: CLLocationCoordinate2D = .startLocation
    
    @Published var cameraPosition: MapCameraPosition = .region(.startRegion)
    
    @Published var mapSelection: Location?
    @Published var navigatedLocation: Location?
    
    @Published var messageError: String?

    @Published var sheetConfig: MapSheetConfig? = nil
    
    @Published var customAnnotation: MKPointAnnotation?

    @Published var showSearch = false
    @Published var isSave = false
    @Published var isDeleted = false
    @Published var isError = false
    @Published var tappedOnAnnotation = false
    
    @Published var routerColor: Color = .blue
    
    private let locationService: FetchLocationFormFirebaseProtocol
    private let fetchLocations: FetchLocationsProtocol
    
    @AppStorage("styleMap") var styleMap: UserMapStyle = .standard
    
    init(locationService: FetchLocationFormFirebaseProtocol,
         fetchLocations: FetchLocationsProtocol) {
        
        self.locationService = locationService
        self.fetchLocations = fetchLocations
        
    }
    
    @MainActor
    func fetchLocationsByCurrentUser(userId: String?) async {
        
        self.isError = false
        self.messageError = nil
        
        do {
            
            if let userId = userId, self.locations.isEmpty {
                
                await fetchLocations.reload()
                self.locations = try await fetchLocations
                    .getLocations(userId: userId, pageSize: pageSize)
                
                getCameraPosition()
                
                loadColor()
            }
            
        } catch {
            self.isError = true
            self.messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    
    @MainActor
    func updateLocationsByCurrentUser(userId: String?) async {
        
        self.isError = false
        self.messageError = nil
        
        do {
            
            guard let userId else { return }
            await fetchLocations.reload()
            self.locations = try await fetchLocations
                .getLocations(userId: userId, pageSize: pageSize)
            
        } catch {
            self.isError = true
            self.messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    @MainActor
    func fetchMoreLocationsByCurentUser(userId: String?) {
        
        Task {
            
            self.isError = false
            self.messageError = nil
            
            do {
                
                guard let userId else { return }
                let fetchingLocation = try await fetchLocations
                    .getLocations(userId: userId, pageSize: pageSize)
                if !fetchingLocation.isEmpty {
                    self.locations.append(contentsOf: fetchingLocation)
                }
                
            } catch {
                self.isError = true
                self.messageError = error.localizedDescription
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    @MainActor
    func addLocation(userId: String?) {
        
        self.isError = false
        self.messageError = nil
        
        guard let userId = userId else { return }
        guard let coordinate = customAnnotation?.coordinate else { return }
        
        Task {
            
            do {
                
                let location = try await locationService.getLocation(
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
                
            } catch {
                self.isError = true
                self.messageError = error.localizedDescription
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
    
    @MainActor
    func updateOrDeleteLocation(userId: String?) {
        
        guard let userId = userId else { return }
        guard let mapSelection = mapSelection else { return }
        self.isError = false
        self.messageError = nil
        
        Task {
            
            do {
                
                switch try await locationService.getLocation(
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
                        isDeleted.toggle()
                    }
                }
                
            } catch {
                self.isError = true
                self.messageError = error.localizedDescription
                Crashlytics.crashlytics().record(error: error)
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
        
        getCameraPosition()
        
    }
    
    func verifyLocation(selectedLocation: Location) -> Location {
        
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
            routerColor = loadedColor
        }
    }
}
