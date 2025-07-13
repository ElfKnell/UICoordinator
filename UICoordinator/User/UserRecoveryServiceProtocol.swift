//
//  UserRecoveryServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/07/2025.
//

import Foundation

protocol UserRecoveryServiceProtocol {
    
    func recovery(_ userId: String?) async throws
    
}
