//
//  CreateUserFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation

class CreateUserFirebase: CreateUserProtocol {
    
    let firestoreService: FirestoreCreateUserProtocol
    
    init(firestoreService: FirestoreCreateUserProtocol) {
        self.firestoreService = firestoreService
    }
    
    func uploadUserData(id: String,
                        withEmail email: String,
                        fullname: String,
                        username: String) async throws {
        
        let user = User(id: id,
                        fullname: fullname,
                        username: username,
                        email: email,
                        isDelete: false)
        
        try await firestoreService.createUserWithUniqueUsername(user: user, username: username)
        
    }
}
