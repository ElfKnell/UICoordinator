//
//  ServiseRouterProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/08/2025.
//

import MapKit

protocol ServiseRouterProtocol {
    
    func getDirections(startingPoint: CLLocationCoordinate2D,
                       endPoint: CLLocationCoordinate2D) async throws -> MKRoute?
    
    func fetchRouter(activityId: String) async throws -> [MKRoute]
    
    func createRoute(activityId: String, route: MKRoute) async throws
    
}
