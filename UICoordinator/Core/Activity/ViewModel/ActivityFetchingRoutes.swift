//
//  ActivityFetchingRoutes.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import MapKit
import SwiftUI

class ActivityFetchingRoutes: ActivityFetchingRoutesProtocol {
    
    let fetchingRoutes: FetchingRoutesServiceProtocol
    
    init(fetchingRoutes: FetchingRoutesServiceProtocol) {
        
        self.fetchingRoutes = fetchingRoutes
        
    }
    
    func getDirections(startingPoint: CLLocationCoordinate2D,
                       endPoint: CLLocationCoordinate2D,
                       transportType: MKDirectionsTransportType?) async throws -> MKRoute? {
        
        return try await retry(maxRetries: 3, delay: 3) {
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: startingPoint))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint))
            request.transportType = transportType ?? .automobile
            
            let directions = MKDirections(request: request)
            let response = try await directions.calculate()
            
            if let route = response.routes.first {
                return route
            } else {
                throw NSError(
                    domain: "RouteError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Route not found"]
                )
            }
            
        }
        
    }
    
    func fetchRouter(activityId: String) async throws -> [RoutePair] {
        
        let storedRoutes = try await fetchingRoutes.fetchRoutes(activityId: activityId)
        
        var result: [RoutePair] = []
        
        for storedRoute in storedRoutes {
            
            guard let newRoute = try await getDirections(
                startingPoint: storedRoute.startCoordinate.clCoordinate,
                endPoint: storedRoute.endCoordinate.clCoordinate,
                transportType: storedRoute.transportType.mkTransportType
            ) else {
                continue
            }
            
            result.append(RoutePair(storedRoute: storedRoute, mkRoute: newRoute))
        }
        
        return result

    }
    
    func retry<T>(
        maxRetries: Int,
        delay: TimeInterval = 2,
        task: @escaping () async throws -> T
    ) async throws -> T {
        
        var lastError: Error?
        
        for attempt in 0 ..< maxRetries {
            do {
                return try await task()
            } catch {
                lastError = error
                
                if attempt < maxRetries - 1 {
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? NSError(
            domain: "RetryError",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
        )
    }
}
