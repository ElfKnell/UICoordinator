//
//  ActivityRouters.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2025.
//

import MapKit
import SwiftUI

class ActivityRouters {
    
    private var routes: [MKRoute] = []
    
    func getRoutes(locations: [Location]) async throws -> [MKRoute] {

        if locations.isEmpty || locations.count == 1 { return []}
        let sortedLoc = locations.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
        let cirlePoint = sortedLoc.count >= 3 ? sortedLoc[0] : nil
        let startLocation = sortedLoc[0]
        let loc = sortedLoc.filter { $0 != startLocation }
        try await getMinRouters(locations: loc, startPoint: startLocation, circlePoint: cirlePoint)

        return self.routes
    }
    
    private func getDirections(startingPoint: Location, endPoint: Location) async throws -> MKRoute? {
            
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
    func getMinRouters(locations: [Location], startPoint: Location, circlePoint: Location?) async throws {
        if locations.isEmpty {
            guard let lastRouter = try await getLastRouter(startPoint: startPoint, endPoint: circlePoint) else { return }
            self.routes.append(lastRouter)
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
        try await getMinRouters(locations: locations, startPoint: sPoint, circlePoint: circlePoint)
    }
    
    private func getLastRouter(startPoint: Location, endPoint: Location?) async throws  -> MKRoute? {
        guard let endPoint = endPoint else { return nil }
        guard let route: MKRoute = try await getDirections(startingPoint: startPoint, endPoint: endPoint) else { return nil}
        
        return route
    }
}
