//
//  UserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task {
            try await fetchCurrentUser()
        }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != currentUid })
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    func updateUserProfile(nickname: String, bio: String, link: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await Firestore.firestore()
                .collection("users")
                .document(currentUid)
                .updateData(["username": nickname, "bio": bio, "link": link])
            try await uploadUser(withUid: currentUid)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        self.currentUser = nil
    }
    
    static func deleteUser(_ user: User) async throws {
        try await Firestore.firestore().collection("users").document(user.id).delete()
    }
    
    func updateUserProfileImage(withImageURL imageURL: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("users").document(currentUid).updateData([
            "profileImageURL": imageURL
        ])
        try await uploadUser(withUid: currentUid)
    }
    
    @MainActor
    private func uploadUser(withUid uid: String) async throws {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        self.currentUser = try snapshot.data(as: User.self)
    }
}
