//
//  ActivityDeleteProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Foundation

protocol ActivityDeleteProtocol {
    
    func deleteActivity(activity: Activity) async throws
    
    func deleteAllActivitiesByUser(userId: String) async throws
    
}
