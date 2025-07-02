//
//  UniqueUsernameChecker.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/06/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UniqueUsernameChecker: UniqueUsernameCheckerProtocol {
    
    func isUsernameAvailable(_ username: String) async throws -> Bool {
        
        let db = Firestore.firestore()
        
        do {
            
            let documentSnapshot = try await db
                .collection("unique_usernames")
                .document(username.lowercased())
                .getDocument()
            
            return !documentSnapshot.exists
        } catch {
            print(error.localizedDescription)
            throw UserError.unknownError(error)
        }
    }
}
