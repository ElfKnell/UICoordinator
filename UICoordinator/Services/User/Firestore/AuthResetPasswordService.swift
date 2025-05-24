//
//  AuthResetPasswordService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/05/2025.
//

import Foundation
import FirebaseAuth

class AuthResetPasswordService: AuthResetPasswordProtocol {
    
    func resetPassword(email: String) async throws {
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
