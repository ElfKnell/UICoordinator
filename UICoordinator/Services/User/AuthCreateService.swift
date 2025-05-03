//
//  AuthCreateService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthCreateService: AuthCreateServiceProtocol {
    
    var errorMessage: String?
    
    private var createUserService: CreateUserProtocol
    
    init(createUserService: CreateUserProtocol) {
        
        self.createUserService = createUserService
    }
    
    func createUser(withEmail email: String,
                    password: String,
                    fullname: String,
                    username: String) async -> Bool {
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            try await createUserService.uploadUserData(id: result.user.uid,
                                            withEmail: email,
                                            fullname: fullname,
                                            username: username)
            
            self.errorMessage = nil
            return true
            
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
