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
    @Published var errorMessage: String?
    
    @Published var searchLocations: [Location] = []
    @Published var savedLocations: [Location] = []
    @Published var routes: [MKRoute] = []
    
    @Published var sheetConfig: MapSheetConfig?
    @Published var mapType: MKMapType = .standard
    
    @Published var getDirections = false
    @Published var isSettings = false
    @Published var isSaved = false
    @Published var isError = false
    @Published var shouldAutoSaveRegion: Bool = true
    @Published var shouldUserLocation: Bool = false
    @Published var shouldRestoreSavedRegion: Bool = false
    
    private let fetchLocatins: FetchLocationsForActivityProtocol
    private let activityUpdate: ActivityUpdateProtocol
    
    init(fetchLocatins: FetchLocationsForActivityProtocol,
         activityUpdate: ActivityUpdateProtocol, activity: Activity) {
        
        self.fetchLocatins = fetchLocatins
        self.activityUpdate = activityUpdate
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
        
        self.isError = false
        self.errorMessage = nil
        
        do {
            if self.activity.typeActivity == .track {
                let locations = await fetchLocatins.getLocations(activityId: self.activity.id)
                self.savedLocations = locations
                let activityRouter = ActivityRouters()
                self.routes = try await activityRouter.getRoutes(locations: savedLocations)
            } else {
                self.savedLocations = await fetchLocatins.getLocations(activityId: self.activity.id)
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.isError = true
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
        
        self.errorMessage = nil
        self.isError = false
        
        do {
            try await activityUpdate.updateActivityCoordinate(region: region, id: self.activity.id)
        } catch {
            self.errorMessage = error.localizedDescription
            self.isError = true
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
}
