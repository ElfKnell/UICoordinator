//
//  UserRecoveryService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/07/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics
import FirebaseFirestoreSwift

class UserRecoveryService: UserRecoveryServiceProtocol {
    
    private let firestore: FirestoreProtocol
    
    init(firestore: FirestoreProtocol) {
        self.firestore = firestore
    }
    
    func recovery(_ userId: String?) async throws {
        do {
            
            guard let userId else {
                throw UserError.userNotFound
            }
            
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["isDelete": false])
           
        } catch UserError.userNotFound {
            Crashlytics.crashlytics().record(error: UserError.userNotFound)
            throw UserError.userNotFound
        } catch {
            Crashlytics.crashlytics().record(error: error)
            throw error
        }
    }
}
