//
//  FetchLocationProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/04/2025.
//

import MapKit

protocol FetchLocationProtocol {
    
    func getLocation(userId: String, coordinate: CLLocationCoordinate2D) -> Location?
    
    func fetchLocation(withId id: String) async throws -> Location
}
