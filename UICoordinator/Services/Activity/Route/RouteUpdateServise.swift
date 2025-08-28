//
//  RouteUpdateServise.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import Foundation
import MapKit
import Firebase

class RouteUpdateServise: RouteUpdateServiseProtocol {
    
    private let routeCollection = "route"
    
    func updateRoute(_ route: RoutePair) async throws {
        
        let coordinates = route.mkRoute.polyline.toCoordinates()
        
        try await Firestore.firestore()
            .collection(routeCollection)
            .document(route.id)
            .updateData([
                "coordinates": coordinates.map { $0.dictionary },
                "transportType": route.storedRoute.transportType.rawValue,
                "distance": route.mkRoute.distance,
                "expectedTime": route.mkRoute.expectedTravelTime
            ])
    }
    
}
