//
//  AuthDeleteUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation

class AuthDeleteUser: AuthDeleteUserProtocol {
    
    func deleteCurrentUser(userSession: FirebaseUserProtocol) async throws {
        
        try await userSession.delete()
    }
    
}
