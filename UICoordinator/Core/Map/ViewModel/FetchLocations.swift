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
    
    private var fetchLocationByUser: FetchLocationsProtocol
    private var pageSize = 25
    
    init() {
        
        self.fetchLocationByUser = FetchLocationsFromFirebase()

    }
    
    func fetchLocation(_ userId: String?) async -> [Location] {
        
        guard let id = userId else { return [] }
        
        let locations = await fetchLocationByUser.getLocations(userId: id, pageSize: pageSize)

        return locations
    }
}
