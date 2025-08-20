//
//  ActivityRouters.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2025.
//

import MapKit
import SwiftUI

class ActivityRouters: ServiseRouterProtocol {
    
    let fetchingRoutes: FetchingRoutesService
    let createRoute: RouteCreateService
    
    init(fetchingRoutes: FetchingRoutesService,
         createRoute: RouteCreateService) {
        
        self.fetchingRoutes = fetchingRoutes
        self.createRoute = createRoute
    }
    
    func getDirections(startingPoint: CLLocationCoordinate2D,
                       endPoint: CLLocationCoordinate2D) async throws -> MKRoute? {
        
        do {
            // Create and configure the request
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingPoint))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint))
            
            //request.transportType = .walking
            request.transportType = .automobile
            // Get the directions based on the request
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            return response.routes.first
            
        } catch let error as NSError {
            
            if error.domain == "GEOErrorDomain" && error.code == -3 {
                
                if let timeUntilReset = error.userInfo["timeUntilReset"] as? Int {
                        print("Throttled request. Waiting for \(timeUntilReset) seconds...")
                        
                        try await Task.sleep(nanoseconds: UInt64(timeUntilReset + 1) * 3_000_000_000)
                        
                        return try await getDirections(startingPoint: startingPoint, endPoint: endPoint)
                }
            }
            throw error
        }
        
    }
    
    func fetchRouter(activityId: String) async throws -> [MKRoute] {
        
        let storedRoutes = try await fetchingRoutes.fetchRoutes(activityId: activityId)
        
        var routes: [MKRoute] = []
        
        for route in storedRoutes {
            
            let newRoute = try await convertRoutes(route: route)
            guard let newRoute else { continue }
            
            routes.append(newRoute)
        }
        
        return routes

    }
    
    func createRoute(activityId: String, route: MKRoute) async throws {
        
        let routeTransportType = RouteTransportType(mkTransportType: route.transportType)
        
        let storedRoute = StoredRoute(
            activityId: activityId,
            route: route,
            transportType: routeTransportType
        )
        
        try await createRoute.uploadRoute(storedRoute)
        
    }
    
    private func convertRoutes(route: StoredRoute) async throws -> MKRoute? {
        
        let rout = try await getDirections(
            startingPoint: route.startCoordinate.clCoordinate,
            endPoint: route.endCoordinate.clCoordinate)
        
        guard let rout else { return nil }
        return rout
        
    }
    
}
