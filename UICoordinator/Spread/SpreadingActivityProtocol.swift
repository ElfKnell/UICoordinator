//
//  SpreadingActivityProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Foundation

protocol SpreadingActivityProtocol {
    
    func createSpread(_ spreadActivity: Spread) async throws
    
    func getSpreads(users: [User], pageSize: Int, byField: String) async throws -> [Spread]
    
    func clean()
}
