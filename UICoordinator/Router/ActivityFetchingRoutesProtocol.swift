//
//  ActivityFetchingRoutesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import MapKit

protocol ActivityFetchingRoutesProtocol {
    
    func getDirections(startingPoint: CLLocationCoordinate2D,
                       endPoint: CLLocationCoordinate2D,
                       transportType: MKDirectionsTransportType?) async throws -> MKRoute?
    
    func fetchRouter(activityId: String) async throws -> [RoutePair]
    
}
