//
//  UserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

class UserService: ObservableObject, UserServiceProtocol {
    
    static let shared = UserService()
    
    @MainActor
    func uploadUserData(id: String, withEmail email: String, fullname: String, username: String) async {
        
        do {
            let user = User(id: id, fullname: fullname, username: username, email: email)
            guard let userData = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(id).setData(userData)
            //self.currentUser = user
        } catch {
            print("ERROR UPDATE USER: \(error.localizedDescription)")
        }
    }
    
    static func fetchUsersByIds(at ids: [String]) async -> [User] {
        
        do {
            if ids.isEmpty { return [] }
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .whereField("id", in: ids)
                .getDocuments()
            return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } catch {
            print("ERROR FETCH USERS at ids: \(error.localizedDescription)")
            return []
        }
    }
    
    static func fetchUsers() async -> [User] {
        
        do {
            guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
            return users.filter({ $0.id != currentUid })
        } catch {
            print("ERROR FETCH USERS: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchUser(withUid uid: String) async -> User {
        
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .getDocument()
            return try snapshot.data(as: User.self)
        } catch {
            print("ERROR FETCH USER: \(error.localizedDescription)")
            return DeveloperPreview.user
        }
        
    }
    
    static func deleteUser(_ user: User) async throws {
        try await Firestore.firestore().collection("users").document(user.id).delete()
    }
    
}
