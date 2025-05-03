//
//  CreateUserFirebase.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CreateUserFirebase: CreateUserProtocol {
    
    private let firestoreService: FirestoreCreateUserProtocol

        init(firestoreService: FirestoreCreateUserProtocol) {
            self.firestoreService = firestoreService
        }
    
    func uploadUserData(id: String, withEmail email: String, fullname: String, username: String) async throws {
        
        let user = User(id: id, fullname: fullname, username: username, email: email, isDelete: false)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await firestoreService.setUserData(id: id, data: userData)
        
    }
}
