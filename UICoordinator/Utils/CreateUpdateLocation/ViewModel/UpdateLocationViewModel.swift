//
//  UpdateLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import Foundation

class UpdateLocationViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    
    func initInfo(location: Location) {
        self.name = location.name
        self.description = location.description
        
        if let address = location.address {
            self.address = address
        }
    }
    
    func deleteLocation(locationId: String) async throws {
        try await LocationService.deleteLocation(locationId: locationId)
    }
    
    func updateLocation(locationId: String) async throws {
        if !self.address.isEmpty {
            try await LocationService.updateAddressLocation(address: self.address, locationId: locationId)
        }
        try await LocationService.updateLocation(name: self.name, description: self.description, locationId: locationId)
    }
}
