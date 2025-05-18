//
//  LocationManager.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/05/2025.
//

import MapKit
import Foundation

final class LocationManager {
    
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var isTrackingAvailable = false
    
    private let locationManager = CLLocationManager()
    
    func checkAndRequestPermission() async {
        let currentStatus = locationManager.authorizationStatus
        authorizationStatus = currentStatus

        if currentStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            authorizationStatus = locationManager.authorizationStatus
        }

        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            isTrackingAvailable = true
        } else {
            isTrackingAvailable = false
        }
    }
}
