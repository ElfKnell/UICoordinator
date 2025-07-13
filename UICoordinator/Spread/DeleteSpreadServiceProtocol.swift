//
//  DeleteSpreadServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 13/07/2025.
//

import Foundation

protocol DeleteSpreadServiceProtocol {
    
    func removeSpreads(_ objectId: String, withType type: SpreadingType) async throws
    
}
