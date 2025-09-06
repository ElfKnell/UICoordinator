//
//  AuthService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Observation
import Firebase
import FirebaseCrashlytics
import FirebaseFirestoreSwift

@Observable
@MainActor
class AuthService: AuthServiceProtocol {
    
    var userSession: FirebaseUserProtocol?
    var errorMessage: String?
    
    private var currentUserService: CurrentUserServiceProtocol
    private var authProvider: FirebaseAuthProviderProtocol
    private var authStaticProvider: FirebaseStaticAuthProviderProtocol
    
    init(currentUserService: CurrentUserServiceProtocol,
         authProvider: FirebaseAuthProviderProtocol,
         authStaticProvider: FirebaseStaticAuthProviderProtocol) {
        
        self.currentUserService = currentUserService
        self.authProvider = authProvider
        self.authStaticProvider = authStaticProvider
    }
    
    func login(withEmail email: String, password: String) async {
        
        do {
            
            let user = try await authProvider.signIn(email: email, password: password)
            self.userSession = user
            try await self.currentUserService.fetchCurrentUser(userId: user.uid)
            self.errorMessage = nil
           
        } catch {
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    func signOut() {
    
        self.errorMessage = nil
        currentUserService.currentUser = nil
        do {
            try authStaticProvider.signOut()
        } catch {
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        userSession = nil
    }
    
    func checkUserSession() async {
        
        if let user = authStaticProvider.currentUser {
            do {
                _ = try await user.idTokenForcingRefresh(true)
                self.userSession = user
                try await currentUserService.fetchCurrentUser(userId: user.uid)
                self.errorMessage = nil
            } catch {
                self.userSession = nil
                self.errorMessage = error.localizedDescription
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
