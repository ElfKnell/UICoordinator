//
//  FetchLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/04/2025.
//

import Firebase
import MapKit
import SwiftUI

class FetchLocations: ObservableObject {
    
    private let fetchLocationByUser: FetchLocationsProtocol
    private let pageSize = 25
    
    init(fetchLocationByUser: FetchLocationsProtocol) {
        
        self.fetchLocationByUser = fetchLocationByUser

    }
    
    func fetchLocations(_ userId: String?) async -> [Location] {
        
        guard let id = userId else { return [] }
        
        let locations = await fetchLocationByUser.getLocations(userId: id, pageSize: pageSize)

        return locations
    }
}
