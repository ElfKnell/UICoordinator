//
//  FetchLocationProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/04/2025.
//

import MapKit

protocol FetchLocationFormFirebaseProtocol {
    
    func getLocation(
        userId: String,
        coordinate: CLLocationCoordinate2D
    ) async throws -> Location?
    
    func fetchLocation(withId id: String) async throws -> Location
    
}
