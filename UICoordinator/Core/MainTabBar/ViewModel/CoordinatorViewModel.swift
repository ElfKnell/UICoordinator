//
//  CoordinatorViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/05/2025.
//

import MapKit
import Foundation

final class CoordinatorViewModel: ObservableObject {
    
    @Published var isLocationServicesEnabled = false
    @Published var mainSelectedTab = 0
    @Published var errorMessage: String?
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
    }
    
    func start() async {
        await locationManager.checkAndRequestPermission()
        await MainActor.run {
            checkLocationAvailability()
        }
    }
    
    @MainActor
    private func checkLocationAvailability() {
        
        if !locationManager.isTrackingAvailable {
            isLocationServicesEnabled = false
            errorMessage = "You have not enabled the location system. As a result, the app may experience limited functionality or reduced accuracy."
        } else {
            isLocationServicesEnabled = true
            errorMessage = nil
        }
        
    }
}
