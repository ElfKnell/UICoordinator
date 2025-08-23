//
//  FetchingRouteServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation

protocol FetchingRouteServiceProtocol {
    
    func fetchStoredRoute(_ id: String) async throws -> StoredRoute?
    
}
