//
//  AuthCreateService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/04/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics
import FirebaseAuth

class AuthCreateService: AuthCreateServiceProtocol {
    
    private var createUserService: CreateUserProtocol
    private var authService: AuthProtocol
    
    init(createUserService: CreateUserProtocol,
         authService: AuthProtocol) {
        
        self.createUserService = createUserService
        self.authService = authService
    }
    
    func createUser(withEmail email: String,
                    password: String,
                    fullname: String,
                    username: String) async throws {
        
        var authDataResult: AuthDataResultProtocol?
        
        do {
            authDataResult = try await authService.createUser(withEmail: email, password: password)
            
            guard let result = authDataResult else {
                throw UserError.userCreateNil
            }
            
            try await createUserService.uploadUserData(id: result.firebaseUser.uid,
                                                       withEmail: result.firebaseUser.email ?? email,
                                                       fullname: fullname,
                                                       username: username)
            
            
        } catch let authError as NSError {
            
            if let user = authDataResult?.firebaseUser {
                try? await user.delete()
            }
            
            if authError.domain == AuthErrorDomain {
                Crashlytics.crashlytics().record(error: authError)
                throw UserError.authCreationFailed(authError)
            } else if authError.domain == "FirestoreErrorDomain" {
                Crashlytics.crashlytics().record(error: authError)
                throw UserError.unknownError(authError)
            } else {
                Crashlytics.crashlytics().record(error: authError)
                throw UserError.unknownError(authError)
            }
            
        } catch {
            
            if let user = authDataResult?.firebaseUser {
                try? await user.delete()
            }
            Crashlytics.crashlytics().record(error: error)
            throw UserError.unknownError(error)
            
        }
    }
}
