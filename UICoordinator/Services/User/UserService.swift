//
//  UserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

class UserService: UserServiceProtocol {
    
    private let firestoreUserDocument: FirestoreServiceProtocol

    init(firestoreUserDocument: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreUserDocument = firestoreUserDocument
    }
    
    func fetchUser(withUid uid: String) async -> User {
        
        do {
            
            let snapshot = try await firestoreUserDocument.getUserDocument(uid: uid)
            return try snapshot.decodeData(as: User.self)
            
        } catch {
            print("ERROR FETCH USER: \(error.localizedDescription)")
            return DeveloperPreview.user
        }
        
    }
    
    func deleteUser() async {
        
        do {
            
            try await firestoreUserDocument.deleteUserDocument()
            
        } catch UserError.userNotFound {
            print("ERROR DELETE USER: \(UserError.userNotFound.description)")
        } catch {
            print("ERROR DELETE USER: \(error.localizedDescription)")
        }
    }
    
}
