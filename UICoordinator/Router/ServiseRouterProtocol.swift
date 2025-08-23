//
//  ServiseRouterProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/08/2025.
//

import MapKit

protocol ServiseRouterProtocol {
    
    func createRoute(activityId: String, route: MKRoute) async throws -> StoredRoute
    
    func updateRoute(route: RoutePair, mkRoute: MKRoute) async throws -> RoutePair
    
    func deleteRoute(_ id: String) async throws
    
}
