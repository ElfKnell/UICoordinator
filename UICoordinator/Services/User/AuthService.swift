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
    
    static var shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async {
        
        do {
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await UserService.shared.fetchCurrentUser()
           
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, passsword: String, fullname: String, username: String) async {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: passsword)
            self.userSession = result.user
            await UserService.shared.uploadUserData(id: result.user.uid, withEmail: email, fullname: fullname, username: username)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        UserService.shared.currentUser = nil
    }
    
}
