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
    
    func fetchLocation(_ userId: String? = nil) async -> [Location] {
        
        var id: String
        
        if let userId = userId {
            id = userId
        } else {
            guard let userId = AuthService.shared.userSession?.uid else { return [] }
            id = userId
        }
        
        return await fetchLocationByUser.getLocations(userId: id, pageSize: pageSize)

    }
}
