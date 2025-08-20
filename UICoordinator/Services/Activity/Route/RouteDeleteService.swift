//
//  RouteDeleteService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation

class RouteDeleteService {
    
    private let routeCollection = "Route"
    let servіceDelete: FirestoreGeneralDeleteProtocol
    
    init(servіceDelete: FirestoreGeneralDeleteProtocol) {
        self.servіceDelete = servіceDelete
    }
    
    func deleteRoute(_ id: String) async throws {
        
        try await self.servіceDelete.deleteDocument(
            from: routeCollection,
            documentId: id
        )
        
    }
}
