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

    init(firestore: FirestoreProtocol = Firestore.firestore()) {
        
        self.firestore = firestore
        
    }
    
    func updateUserProfile(userId: String, nickname: String, bio: String, link: String) async {
        
        do {
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["username": nickname, "bio": bio, "link": link])
            
        } catch {
            print("ERROR UPDATE USER PROFILE:\(error.localizedDescription)")
        }
    }
    
    func updateUserProfileImage(withImageURL imageURL: String, userId: String) async {
        
        do {
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["profileImageURL": imageURL])
            
        } catch {
            print("ERROR UPDATE USER PROFILE PHOTO: \(error.localizedDescription)")
        }
    }
    
    func deleteUser(userId: String?) async {
        
        do {
            
            guard let userId else { throw UserError.userNotFound }
            
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["isDelete": true])
           
        } catch UserError.userNotFound {
            print("ERROR DELETE USER: \(UserError.userNotFound.description)")
        } catch {
            print("ERROR DELETE USER: \(error.localizedDescription)")
        }
    }
    
    func updateUserPrivate(isPrivateProfile: Bool, userId: String) async {
        
        do {
            try await firestore
                .collection("users")
                .document(userId)
                .updateData(["isPrivateProfile": isPrivateProfile])
            
        } catch {
            print("ERROR UPDATE USER PROFILE PHOTO: \(error.localizedDescription)")
        }
    }
}
