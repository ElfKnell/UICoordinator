//
//  ActivityRouters.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2025.
//

import MapKit
import SwiftUI
import Firebase

class ActivityRouters: ServiseRouterProtocol {
    
    let createRoute: CreateRouterProtocol
    let updateService: RouteUpdateServiseProtocol
    let deleteService: RouteDeleteServiceProtocol
    
    init(
         createRoute: CreateRouterProtocol,
         updateService: RouteUpdateServiseProtocol,
         deleteService: RouteDeleteServiceProtocol) {
        
        self.createRoute = createRoute
        self.updateService = updateService
        self.deleteService = deleteService
    }
    
    func createRoute(activityId: String, route: MKRoute) async throws -> StoredRoute {
        
        let newRouteID = Firestore.firestore()
            .collection("Route")
            .document()
            .documentID

        let routeTransportType = RouteTransportType(mkTransportType: route.transportType)
        
        let storedRoute = StoredRoute(
            routeId: newRouteID,
            activityId: activityId,
            route: route,
            transportType: routeTransportType
        )
        
        try await createRoute.uploadRoute(storedRoute)
        
        return storedRoute
        
    }
    
    func updateRoute(route: RoutePair, mkRoute: MKRoute) async throws -> RoutePair {
        
        let newRoutePair = RoutePair(storedRoute: route.storedRoute, mkRoute: mkRoute)
        
        try await updateService.updateRoute(newRoutePair)
        
        return newRoutePair
        
    }
    
    func deleteRoute(_ id: String) async throws {
        
        try await deleteService.deleteRoute(id)
        
    }
    
}
