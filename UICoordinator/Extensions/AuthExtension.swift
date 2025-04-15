//
//  AuthExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/04/2025.
//

import Firebase

extension Auth: FirebaseAuthProviding {
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signInFirebase(withEmail: email, password: password)
    }
    
}

extension Auth {
    func signInFirebase(withEmail email: String, password: String) async throws -> AuthDataResult {
        try await self.signIn(withEmail: email, password: password)
    }
}
