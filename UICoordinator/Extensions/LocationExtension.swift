//
//  LocationExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    static var startLocation: CLLocationCoordinate2D {
        return .init(latitude: 0.0, longitude: 0.0)
    }
}

extension MKCoordinateRegion {
    static var startRegion: MKCoordinateRegion {
        return .init(center: .startLocation, span: MKCoordinateSpan(latitudeDelta: 180.0, longitudeDelta: 180.0))
    }
}
