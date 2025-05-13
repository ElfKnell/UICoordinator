//
//  ActivityDeleteProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/05/2025.
//

import Foundation

protocol ActivityDeleteProtocol {
    
    func markActivityForDelete(activityId: String) async
    
    func deleteActivity(activityId: String) async
}
