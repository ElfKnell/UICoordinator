//
//  AuthDeleteUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation

protocol AuthDeleteUserProtocol {
    
    func deleteCurrentUser(userSession: FirebaseUserProtocol) async throws
    
}
