//
//  AuthService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseFirestoreSwift


class AuthService: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    
    private var createUser = CreateUserFirebase(firestoreService: FirestoreCreateUserService())
    
    @MainActor
    func login(withEmail email: String, password: String) async {
        
        do {
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await CurrentUserService.sharedCurrent.fetchCurrentUser(userId: self.userSession?.uid)
           
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, passsword: String, fullname: String, username: String) async {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: passsword)
            self.userSession = result.user
            await createUser.uploadUserData(id: result.user.uid, withEmail: email, fullname: fullname, username: username)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        CurrentUserService.sharedCurrent.currentUser = nil
    }
    
    @MainActor
    func checkUserSession() async {
        
        if let user = Auth.auth().currentUser {
            do {
                try await user.idTokenForcingRefresh(true)
                self.userSession = user
                await CurrentUserService.sharedCurrent.fetchCurrentUser(userId: self.userSession?.uid)
                print("✅ User still logged in with token.")
            } catch {
                print("❌ Token refresh failed: \(error.localizedDescription)")
            }
        } else {
            print("🚫 No user is currently logged in")
        }
    }
}
