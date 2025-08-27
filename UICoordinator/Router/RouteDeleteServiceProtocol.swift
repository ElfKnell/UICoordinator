//
//  RouteDeleteServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import Foundation

protocol RouteDeleteServiceProtocol {
    
    func deleteRoute(_ id: String) async throws
    
    func deleteByActivity(activityId: String) async throws
    
}
