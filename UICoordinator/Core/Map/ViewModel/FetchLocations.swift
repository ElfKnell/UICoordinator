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
    
    private var fetchLocationByUser: UserLocationsProtocol
    private var pageSize = 25
    
    init() {
        
        self.fetchLocationByUser = GetUserLocationFromFirebase()

    }
    
    func fetchLocation(_ userId: String?) async throws -> [Location] {
        
        do {
            
            var id: String
            if let userId = userId {
                id = userId
            } else {
                guard let userId = AuthService.shared.userSession?.uid else { return [] }
                id = userId
            }
            
            return try await fetchLocationByUser.getLocation(userId: id, pageSize: pageSize)

        } catch {
            
            print("ERROR: \(error.localizedDescription)")
            return []
        }
    }
}
