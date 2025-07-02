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
    
    private var createUserService: CreateUserProtocol
    
    init(createUserService: CreateUserProtocol) {
        
        self.createUserService = createUserService
    }
    
    func createUser(withEmail email: String,
                    password: String,
                    fullname: String,
                    username: String) async throws {
        
        var result: AuthDataResult?
        
        do {
            result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            guard let result else {
                throw UserError.userCreateNil
            }
            
            try await createUserService.uploadUserData(id: result.user.uid,
                                            withEmail: email,
                                            fullname: fullname,
                                            username: username)
            
            
        } catch let authError as NSError {
            
            if let user = result?.user {
                try? await user.delete()
            }
            
            throw UserError.authCreationFailed(authError)
        } catch {
            
            if let user = result?.user {
                try? await user.delete()
            }
            
            throw UserError.unknownError(error)
        }
    }
}
