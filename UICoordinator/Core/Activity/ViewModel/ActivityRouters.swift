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
        
        var remainingLocations = Array(sortedLoc.dropFirst())
        
        var currentPoint = sortedLoc[0]
        var routes: [MKRoute] = []
        
        while !remainingLocations.isEmpty {
            
            var minRouter: MKRoute?
            var nextPoint: Location?
            
            for location in remainingLocations {
                do {
                    if let router = try await getDirections(startingPoint: currentPoint, endPoint: location) {
                        if minRouter == nil || router.expectedTravelTime < minRouter!.expectedTravelTime {
                            minRouter = router
                            nextPoint = location
                        }
                    }
                } catch {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
            }
                
            if let minRouter, let nextPoint {
                
                routes.append(minRouter)
                currentPoint = nextPoint
                remainingLocations.removeAll(where: { $0 == nextPoint })
                
            } else {
                break
            }
        }
        
        if locations.count >= 3, let lastRoute = try await getLastRouter(startPoint: currentPoint, endPoint: sortedLoc[0]) {
            routes.append(lastRoute)
        }
        
        return routes
    }
    
    private func getDirections(startingPoint: Location, endPoint: Location) async throws -> MKRoute? {
        
        do {
            // Create and configure the request
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingPoint.coordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint.coordinate))
            
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
                        
                        try await Task.sleep(nanoseconds: UInt64(timeUntilReset + 1) * 1_000_000_000)
                        
                        return try await getDirections(startingPoint: startingPoint, endPoint: endPoint)
                }
            }
            throw error
        }

    }
    
    private func getLastRouter(startPoint: Location, endPoint: Location?) async throws  -> MKRoute? {
        
        guard let endPoint = endPoint else { return nil }
        return try await getDirections(startingPoint: startPoint, endPoint: endPoint)
    }
}
