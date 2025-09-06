//
//  FirebaseAuthCreateService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation
import FirebaseAuth

class FirebaseAuthCreateService: AuthProtocol {
    
    func createUser(withEmail email: String,
                    password: String) async throws -> AuthDataResultProtocol? {
        
        let authDataResult = try await Auth.auth()
            .createUser(withEmail: email, password: password)
        return authDataResult
        
    }
}
