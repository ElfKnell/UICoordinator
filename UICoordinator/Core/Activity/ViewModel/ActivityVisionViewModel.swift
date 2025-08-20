//
//  ActivityRoutesViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/10/2024.
//

import MapKit
import SwiftUI
import Firebase

class ActivityVisionViewModel: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var searchLocations = [Location]()
    @Published var routes: [MKRoute] = []
    @Published var routesNew: [MKRoute] = []
    @Published var selectedPlace: Location?
    @Published var originLocation: Location?
    @Published var errorMessage: String?

    @Published var isError = false
    @Published var isLoadingRoutes = false
    @Published var isMark = false
    @Published var isSettings = false
    @Published var isSelected = false
    @Published var isSelectingDestination = false
    
    @Published var sheetConfig: MapSheetConfig?
    
    private let fetchLocatins: FetchLocationsForActivityProtocol
    private let activityUpdate: ActivityUpdateProtocol
    private let serviceRoutes: ServiseRouterProtocol
    
    init(fetchLocatins: FetchLocationsForActivityProtocol,
         activityUpdate: ActivityUpdateProtocol,
         serviceRoutes: ServiseRouterProtocol) {
       
        self.fetchLocatins = fetchLocatins
        self.activityUpdate = activityUpdate
        self.serviceRoutes = serviceRoutes
    }
    
    @MainActor
    func getLocation(activityId: String) async {
        
        do {
            
            self.locations = try await fetchLocatins.getLocations(activityId: activityId)
            
        } catch {
            handle(error)
        }
    }
    
    @MainActor
    func loadRoutesIfNeeded(activityId: String) async {
        
        isLoadingRoutes = true
        defer { isLoadingRoutes = false }
        
        do {
            
            if routes.isEmpty {
                let newRoutes = try await serviceRoutes.fetchRouter(activityId: activityId)
                self.routes = newRoutes
            }
            
        } catch {
            handle(error)
        }
    }
    
    @MainActor
    func clean() {
        self.routes.removeAll(where: { routesNew.contains($0) })
        self.originLocation = nil
        self.selectedPlace = nil
    }
    
    func initialCamera(for activity: Activity) -> MapCameraPosition {
        if let region = activity.region {
            return .region(region)
        } else {
            return .userLocation(fallback: .automatic)
        }
    }
    
    func infoView() {
        if sheetConfig == .confirmationLocation {
            sheetConfig = nil
        } else {
            sheetConfig = .confirmationLocation
        }
    }
    
    func verifyLocation(selectedLocation: Location) -> Location {
        
        let locationVerifyId = locations.firstIndex(where: {
            $0.longitude == selectedLocation.longitude &&
            $0.latitude == $0.latitude
        })
        
        if let id = locationVerifyId {
            return locations[id]
        } else {
            return selectedLocation
        }
    }
    
    func startSelectingDestination() {
        guard let origin = selectedPlace else { return }
        originLocation = origin
        isSelectingDestination = true
        isSelected = false
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
            self.routesNew.append(newRoute)
            
            self.isSelectingDestination = false
            
        } catch {
            handle(error)
        }
    }
    
    func midpoint(of polyline: MKPolyline) -> CLLocationCoordinate2D {
        
        let pointCount = polyline.pointCount
        guard pointCount > 1 else {
            return polyline.coordinate
        }

        let points = polyline.points()
        let midIndex = pointCount / 2
        return points[midIndex].coordinate
        
    }
    
    private func handle(_ error: Error) {
        self.errorMessage = error.localizedDescription
        self.isError = true
    }
}

