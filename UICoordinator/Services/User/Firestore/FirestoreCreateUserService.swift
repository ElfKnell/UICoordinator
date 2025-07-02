//
//  FirestoreCreateUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreCreateUserService: FirestoreCreateUserProtocol {
    
    private let db: FirestoreProtocol
    
    init(firestoreInstance: FirestoreProtocol) {
        self.db = firestoreInstance
    }
    
    func createUserWithUniqueUsername(user: User, username: String) async throws {
        
        let lowercasedUsername = username.lowercased()
        
        _ = try await db.runTransaction { (transaction, errorPointer) -> Any? in
            
            let userDocRef = transaction.collection("users")
            let uniqueUsernameDocRef = transaction.collection("unique_usernames")
            
            do {
                let existingUniqueDoc = try transaction.getDocument(uniqueUsernameDocRef
                    .document(lowercasedUsername))
                
                if existingUniqueDoc.exists {
                    let nsError = NSError(domain: "AuthError",
                                          code: 409,
                                          userInfo: [NSLocalizedDescriptionKey: UserError.usernameTakenDuringRegistration.localizedDescription])
                    guard let pointer = errorPointer else {
                        print("DEBUG: errorPointer was nil in service's updateBlock. Cannot set error.")
                        return nil
                    }
                    pointer.pointee = nsError
                    return nil
                }
                
                try transaction.setData(from: user, forDocument: userDocRef.document(user.id))
                
                let uniqueEntry = UniqueUsernameEntry(userId: user.id, time: Timestamp())
                
                try transaction.setData(from: uniqueEntry,
                                        forDocument: uniqueUsernameDocRef
                    .document(lowercasedUsername))
                
                return nil
            } catch let error as NSError {
                guard let pointer = errorPointer else {
                    print("DEBUG: errorPointer was nil in service's catch block. Cannot set error.")
                    return nil
                }
                pointer.pointee = error
                return nil
            } catch {
                guard let pointer = errorPointer else {
                    print("DEBUG: errorPointer was nil in service's generic catch block. Cannot set error.")
                    return nil
                }
                pointer.pointee = error as NSError
                return nil
            }
        }
    }
    
}
