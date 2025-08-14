//
//  CoordinateKey.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/08/2025.
//

import MapKit

struct CoordinateKey: Hashable {
    
    let lat: Int
    let lot: Int
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.lat = Int(coordinate.latitude * 1_000_000)
        self.lot = Int(coordinate.longitude * 1_000_000)
    }
}
