//
//  RouteCreateService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation
import Firebase

class RouteCreateService {
    
    private let routeCollection = "Route"
    let serviceCreate: FirestoreGeneralCreateServiseProtocol
    
    init(serviceCreate: FirestoreGeneralCreateServiseProtocol = FirestoreGeneralServiceCreate()) {
        self.serviceCreate = serviceCreate
    }
    
    func uploadRoute(_ route: StoredRoute) async throws {
        
        guard let activityRoute = try? Firestore.Encoder()
            .encode(route) else {
            throw ErrorActivity.encodingFailedRoute
        }
        
        try await self.serviceCreate.addDocument(from: routeCollection, data: activityRoute)
    }
    
}
