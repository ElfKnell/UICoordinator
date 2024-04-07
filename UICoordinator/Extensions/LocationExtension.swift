//
//  LocationExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import MapKit

extension CLLocationCoordinate2D {
    static var startLocation: CLLocationCoordinate2D {
        return .init(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion {
    static var startRegion: MKCoordinateRegion {
        return .init(center: .startLocation, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    }
}
