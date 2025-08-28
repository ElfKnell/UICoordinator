//
//  RouteDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation

class RouteDeleteService: RouteDeleteServiceProtocol {
    
    private let routeCollection = "route"
    let servіceDelete: FirestoreGeneralDeleteProtocol
    let fetchingRoutes: FetchingRoutesServiceProtocol
    
    init(servіceDelete: FirestoreGeneralDeleteProtocol,
         fetchingRoutes: FetchingRoutesServiceProtocol) {
        self.servіceDelete = servіceDelete
        self.fetchingRoutes = fetchingRoutes
    }
    
    func deleteRoute(_ id: String) async throws {
        
        try await self.servіceDelete.deleteDocument(
            from: routeCollection,
            documentId: id
        )
        
    }
    
    func deleteByActivity(activityId: String) async throws {
        
        let routes = try await fetchingRoutes.fetchRoutes(activityId: activityId)
        
        for route in routes {
            try await deleteRoute(route.id)
        }
        
    }
}
