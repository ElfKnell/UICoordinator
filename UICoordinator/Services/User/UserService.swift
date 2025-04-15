//
//  UserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

class UserService: ObservableObject {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task {
            await fetchCurrentUser()
        }
    }
    
    @MainActor
    func fetchCurrentUser() async {
        
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    func uploadUserData(id: String, withEmail email: String, fullname: String, username: String) async {
        
        do {
            let user = User(id: id, fullname: fullname, username: username, email: email)
            guard let userData = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(id).setData(userData)
            self.currentUser = user
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
    
    static func fetchUser(withUid uid: String) async -> User {
        
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
    
    static func updateUserProfile(nickname: String, bio: String, link: String) async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(currentUid)
                .updateData(["username": nickname, "bio": bio, "link": link])
            try await UserService.shared.uploadUser(withUid: currentUid)
        } catch {
            print("ERROR UPDATE USER PROFILE:\(error.localizedDescription)")
        }
    }
    
    static func deleteUser(_ user: User) async throws {
        try await Firestore.firestore().collection("users").document(user.id).delete()
    }
    
    static func updateUserProfileImage(withImageURL imageURL: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageURL": imageURL
        ])
        try await UserService.shared.uploadUser(withUid: currentUid)
    }
    
    @MainActor
    private func uploadUser(withUid uid: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
    }
}
