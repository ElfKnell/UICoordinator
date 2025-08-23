//
//  FetchingRoutesServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import Foundation

protocol FetchingRoutesServiceProtocol {
    
    func fetchRoutes(activityId: String) async throws -> [StoredRoute]
    
}
