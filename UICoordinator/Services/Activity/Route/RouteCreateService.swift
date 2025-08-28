//
//  RouteCreateService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation
import Firebase

class RouteCreateService: CreateRouterProtocol {
    
    private let routeCollection = "route"
    let serviceCreate: FirestoreAddDocumentWithIDProtocol
    
    init(serviceCreate: FirestoreAddDocumentWithIDProtocol) {
        self.serviceCreate = serviceCreate
    }
    
    func uploadRoute(_ route: StoredRoute) async throws {
        
        guard let storedId = route.routeId else {
            throw ErrorActivity.idNotFound
        }
        
        guard let activityRoute = try? Firestore.Encoder()
            .encode(route) else {
            throw ErrorActivity.encodingFailedRoute
        }
        
        try await self.serviceCreate.setDocument(
            from: routeCollection,
            data: activityRoute,
            routeID: storedId)
        
    }
    
}
