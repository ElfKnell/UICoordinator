//
//  UserServiceUpdate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/04/2025.
//

import Firebase
import FirebaseFirestoreSwift

class UserServiceUpdate: UserServiceUpdateProtocol {
    
    private let firestore: FirestoreProtocol
    private let imageUpload: ImageUploaderProtocol
    private let logger: LoggerProtocol

    init(firestore: FirestoreProtocol,
         imageUpload: ImageUploaderProtocol,
         logger: LoggerProtocol) {
        
        self.firestore = firestore
        self.imageUpload = imageUpload
        self.logger = logger
        
    }
    
    func updateUserProfile(user: User, image: UIImage?, dataUser: [String: Any]) async throws {
        
        do {
            var updatedData = dataUser
            
            if let image {
                let imageURL = try await imageUpload.uploadeImage(image, currentUser: user)
                updatedData["profileImageURL"] = imageURL
            }
            
            if let username = dataUser["username"] as? String,
                user.username.lowercased() != username.lowercased() {
                try await updateUserWithUniqueUsername(user: user,
                                                       username: username,
                                                       dataUser: updatedData)
            } else {
                
                let userDoc = firestore
                    .collection("users")
                    .document(user.id) as DocumentReferenceProtocol
                try await userDoc.updateData(updatedData)
            }
        } catch {
            throw error
        }
    }
    
    func deleteUser(userId: String?) async {
        
        do {
            
            guard let userId else {
                throw UserError.userNotFound
            }
            
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["isDelete": true])
           
        } catch UserError.userNotFound {
            logger.log("ERROR DELETE USER: \(UserError.userNotFound.description)")
        } catch {
            logger.log("ERROR DELETE USER: \(error.localizedDescription)")
        }
    }
    
    private func updateUserWithUniqueUsername(user: User, username: String, dataUser: [String: Any]) async throws {
        
        let lowercasedUsername = username.lowercased()
        let currentUsername = user.username.lowercased()
        
        _ = try await firestore.runTransaction { (transaction, errorPointer) -> Any? in
            
            let userDocRef = transaction.collection("users")
            let uniqueUsernameDocRef = transaction.collection("unique_usernames")
            
            do {
                let existingUniqueDoc = try transaction.getDocument(uniqueUsernameDocRef
                    .document(lowercasedUsername))
                
                if existingUniqueDoc.exists {
                    let nsError = NSError(domain: "AuthError",
                                          code: 409,
                                          userInfo: [NSLocalizedDescriptionKey: "Username was taken during registration. Please try again."])
                    errorPointer?.pointee = nsError
                    return nil
                }
                
                try transaction.updateData(dataUser, forDocument: userDocRef.document(user.id))
                
                let uniqueEntry = UniqueUsernameEntry(userId: user.id, time: Timestamp())
                
                try transaction.setData(from: uniqueEntry,
                                        forDocument: uniqueUsernameDocRef
                    .document(lowercasedUsername))
                try transaction.deleteDocument(uniqueUsernameDocRef.document(currentUsername))
                
                return nil
            } catch let error as NSError {
                errorPointer?.pointee = error
                return nil
            } catch {
                let nsError = NSError(
                    domain: "FirestoreCreateUserService",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                errorPointer?.pointee = nsError
                return nil
            }
        }
    }
}
