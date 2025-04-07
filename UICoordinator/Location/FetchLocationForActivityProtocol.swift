//
//  FetchLocationForActivityProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/04/2025.
//

import MapKit

protocol FetchLocationForActivityProtocol {
    
    func getLocation(coordinate: CLLocationCoordinate2D, activityId: String) -> Location?
    
}
