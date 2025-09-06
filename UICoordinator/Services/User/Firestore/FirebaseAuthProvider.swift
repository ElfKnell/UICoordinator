//
//  FirebaseAuthProvider.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/05/2025.
//

import Foundation
import Firebase

class FirebaseAuthProvider: FirebaseAuthProviderProtocol {
    
    func signIn(email: String, password: String) async throws -> any FirebaseUserProtocol {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
}
