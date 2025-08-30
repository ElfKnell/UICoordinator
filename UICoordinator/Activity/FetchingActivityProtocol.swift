//
//  FetchingActivityProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import Firebase
import Foundation

protocol FetchingActivityProtocol {
    
    func fetchActivity(documentId: String) async throws -> Activity
    
    func fetchActivity(time: Timestamp, userId: String) async throws -> Activity?
    
}
