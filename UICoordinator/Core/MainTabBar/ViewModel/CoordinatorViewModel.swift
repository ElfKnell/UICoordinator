//
//  CoordinatorViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/05/2025.
//

import MapKit
import Foundation

class CoordinatorViewModel: ObservableObject {
    
    @Published var isLocationServicesEnabled = false
    @Published var mainSelectedTab = 0
    @Published var errorMessage: String?
    private let locationManager = LocationManager()
    
    init() {
        Task {
            await locationManager.checkAndRequestPermission()
        }
    }
    
    @MainActor
    func availabilityCheck() {
        if !locationManager.isTrackingAvailable {
            isLocationServicesEnabled = false
            errorMessage = "You have not enabled the location system. As a result, the app may experience limited functionality or reduced accuracy."
        }
    }
}
