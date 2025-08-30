//
//  FetchingActivitiesProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import Foundation

protocol FetchingActivitiesProtocol {
    
    func fetchActivities(users: [User], pageSize: Int) async throws -> [Activity]
    
    func fetchActivitiesByUser(user: User, pageSize: Int) async throws -> [Activity]
    
    func clean()
}
