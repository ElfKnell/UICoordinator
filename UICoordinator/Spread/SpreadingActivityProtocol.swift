//
//  SpreadingActivityProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Foundation

protocol SpreadingActivityProtocol {
    func createSpread(_ spreadActivity: Spread) async
    
    func getSpreads(users: [User], pageSize: Int, byField: String) async -> [Spread]
    
    func clean()
}
