//
//  UserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseCrashlytics
import FirebaseFirestoreSwift

class UserService: UserServiceProtocol {
    
    private let firestoreUserDocument: FirestoreServiceProtocol

    init(firestoreUserDocument: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreUserDocument = firestoreUserDocument
    }
    
    func fetchUser(withUid uid: String) async throws -> User {
        
        do {
            
            let snapshot = try await firestoreUserDocument.getUserDocument(uid: uid)
            return try snapshot.decodeData(as: User.self)
            
        } catch {
            
            Crashlytics.crashlytics().record(error: UserError.userNotFound)
            throw UserError.userNotFound
            
        }
        
    }
}
