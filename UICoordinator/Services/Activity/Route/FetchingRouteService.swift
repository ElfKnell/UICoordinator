//
//  FetchingRouteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import Firebase

class FetchingRouteService: FetchingRouteServiceProtocol {
    
    private let routeCollection = "route"
    private let db = Firestore.firestore()
    
    func fetchStoredRoute(_ id: String) async throws -> StoredRoute? {
        
        let snapshot = try await Firestore.firestore()
            .collection(routeCollection)
            .document(id)
            .getDocument()
        
        return try snapshot.data(as: StoredRoute.self)
    }
}
