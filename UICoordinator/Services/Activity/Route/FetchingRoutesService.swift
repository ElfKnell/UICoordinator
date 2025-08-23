//
//  FetchingRoutesService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Firebase
import Foundation

class FetchingRoutesService: FetchingRoutesServiceProtocol {
    
    private let routeCollection = "Route"
    
    func fetchRoutes(activityId: String) async throws -> [StoredRoute] {
        
        let snapshot = try await Firestore
            .firestore()
            .collection(routeCollection)
            .whereField("activityId", isEqualTo: activityId)
            .order(by: "createTime", descending: false)
            .getDocuments()
        
        return snapshot.documents.compactMap {
            try? $0.data(as: StoredRoute.self)
        }
        
    }
}
