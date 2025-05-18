//
//  AuthService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Observation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

@Observable
@MainActor
class AuthService: AuthServiceProtocol {
    
    var userSession: FirebaseUserProtocol?
    var errorMessage: String?
    
    private var currentUserService: CurrentUserServiceProtocol
    private var authProvider: FirebaseAuthProviderProtocol
    
    init(currentUserService: CurrentUserServiceProtocol, authProvider: FirebaseAuthProviderProtocol) {
        
        self.currentUserService = currentUserService
        self.authProvider = authProvider
    }
    
    func login(withEmail email: String, password: String) async {
        
        do {
            
            let user = try await authProvider.signIn(email: email, password: password)
            self.userSession = user
            try await self.currentUserService.fetchCurrentUser(userId: user.uid)
            self.errorMessage = nil
           
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() {
    
        currentUserService.currentUser = nil
        try? Auth.auth().signOut()
        userSession = nil
    }
    
    func checkUserSession() async {
        
        if let user = Auth.auth().currentUser {
            do {
                try await user.idTokenForcingRefresh(true)
                self.userSession = user
                try await currentUserService.fetchCurrentUser(userId: user.uid)
                
            } catch {
                print("❌ Token refresh failed: \(error.localizedDescription)")
            }
        }
    }
    
    func resetPassword(email: String) async {
        do {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
