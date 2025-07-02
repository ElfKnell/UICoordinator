//
//  UniqueUsernameCheckerProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/06/2025.
//

import Foundation

protocol UniqueUsernameCheckerProtocol {
    
    func isUsernameAvailable(_ username: String) async throws -> Bool
    
}
