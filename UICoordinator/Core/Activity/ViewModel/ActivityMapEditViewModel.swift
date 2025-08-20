//
//  TestMapViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/08/2025.
//

import MapKit
import SwiftUI

class ActivityMapEditViewModel: ObservableObject {
    
    @Published var activity: Activity {
        didSet {
            updateMapTypeFromActivity()
        }
    }
    
    @Published var region: MKCoordinateRegion {
        didSet {
            
            self.cameraPosition = .region(region)
            updateCanRestoreSavedRegion()
            guard shouldAutoSaveRegion else { return }
            
            Task {
                await saveRegion(region)
            }
            
        }
    }
    
    @Published var cameraPosition: MapCameraPosition
    @Published var customAnnotation: MKPointAnnotation?
    @Published var selectedLocation: Location?
    @Published var originLocation: Location?
    @Published var errorMessage: String?
    
    @Published var searchLocations: [Location] = []
    @Published var savedLocations: [Location] = []
    @Published var routes: [MKRoute] = []
    
    @Published var sheetConfig: MapSheetConfig?
    @Published var mapType: MKMapType = .standard
    
    @Published var isSettings = false
    @Published var isError = false
    @Published var isLoadingRoutes = false
    @Published var shouldAutoSaveRegion: Bool = true
    @Published var shouldUserLocation: Bool = false
    @Published var shouldRestoreSavedRegion: Bool = false
    
    @Published var isSelectingDestination: Bool = false
    @Published var showClearButton: Bool = false
    
    private let fetchLocatins: FetchLocationsForActivityProtocol
    private let activityUpdate: ActivityUpdateProtocol
    private let serviceRoutes: ServiseRouterProtocol
    
    init(fetchLocatins: FetchLocationsForActivityProtocol,
         activityUpdate: ActivityUpdateProtocol,
         serviceRoutes: ServiseRouterProtocol,
         activity: Activity) {
        
        self.fetchLocatins = fetchLocatins
        self.activityUpdate = activityUpdate
        self.serviceRoutes = serviceRoutes
        self.activity = activity
        
        let center = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        let defaultRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        let initialRegion = activity.region ?? defaultRegion
        let shouldAutoSaving: Bool = !(activity.region != nil)
        
        self._shouldAutoSaveRegion = Published(initialValue: shouldAutoSaving)
        self._region = Published(initialValue: initialRegion)
        self._cameraPosition = Published(initialValue: .region(initialRegion))
        let userMapStyle = activity.mapStyle?.mkMapType ?? .standard
        self._mapType = Published(initialValue: userMapStyle)
    }
    
    @MainActor
    func getLocation() async {
        
        do {
            
            self.savedLocations = try await fetchLocatins.getLocations(activityId: self.activity.id)
            
            self.customAnnotation = nil
            
        } catch {
            handle(error)
        }
    }
    
    @MainActor
    func loadRoutesIfNeeded() async {
        
        isLoadingRoutes = true
        defer { isLoadingRoutes = false }
        
        do {
            
            if routes.isEmpty {
                let newRoutes = try await serviceRoutes.fetchRouter(activityId: activity.id)
                self.routes = newRoutes
            }
            
        } catch {
            handle(error)
        }
    }
    
    @MainActor
    func manuallySaveRegion() {
        Task {
            await saveRegion(self.region)
            self.shouldAutoSaveRegion = false
        }
    }
    
    @MainActor
    private func saveRegion(_ region: MKCoordinateRegion) async {

        do {
            try await activityUpdate.updateActivityCoordinate(region: region, id: self.activity.id)
        } catch {
            handle(error)
        }
    }
    
    @MainActor
    func restoreSavedRegion() {
        guard let region = self.activity.region else { return }
        updateRegion(to: region)
    }
    
    @MainActor
    func updateRegion(to region: MKCoordinateRegion, shouldSave: Bool = false) {
        self.shouldAutoSaveRegion = shouldSave
        self.region = region
    }
    
    func startSelectingDestination() {
        guard let origin = selectedLocation else { return }
        originLocation = origin
        isSelectingDestination = true
    }
    
    func clean() {
        self.routes.removeAll()
        self.originLocation = nil
        self.selectedLocation = nil
    }
    
    @MainActor
    func buildRoute(to destination: Location) async {
        
        do {
            guard let origin = self.originLocation else {
                throw ErrorActivity.locationNotFound
            }
            
            let route = try await serviceRoutes.getDirections(
                startingPoint: origin.coordinate,
                endPoint: destination.coordinate)
            
            guard let newRoute = route else {
                throw ErrorActivity.routeNotFound
            }
            
            self.routes.append(newRoute)
            
            try await serviceRoutes.createRoute(activityId: activity.id, route: newRoute)
            
            self.isSelectingDestination = false
            
        } catch {
            handle(error)
        }
    }
    
    func saveLocations() async {
        
        do {
            
            var locationId = [String]()
            for location in self.savedLocations {
                locationId.append(location.id)
            }
            
            try await activityUpdate.updateActivityLocations(
                locationsId: locationId,
                id: self.activity.id
            )
            
        } catch {
            handle(error)
        }
    }
    
    private func updateCanRestoreSavedRegion() {
        
        guard let saved = self.activity.region else {
            self.shouldRestoreSavedRegion = false
            return
        }
        
        let currentCenter = self.region.center
        
        let hasMoved = abs(currentCenter.latitude - saved.center.latitude) > 0.001 || abs(currentCenter.longitude - saved.center.longitude) > 0.001
        
        self.shouldRestoreSavedRegion = hasMoved
    }
    
    private func updateMapTypeFromActivity() {
        if let mapType = activity.mapStyle?.mkMapType {
            self.mapType = mapType
        }
    }
    
    private func handle(_ error: Error) {
        self.errorMessage = error.localizedDescription
        self.isError = true
    }
}
