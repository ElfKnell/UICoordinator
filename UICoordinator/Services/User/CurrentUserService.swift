//
//  CurrentUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Observation
import Firebase
import FirebaseFirestoreSwift

@Observable
class CurrentUserService: CurrentUserServiceProtocol {
    
    var currentUser: User?
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol) {
        
        self.firestoreService = firestoreService
    }
    
    func fetchCurrentUser(userId: String?) async throws {
        
        guard let userId else { throw UserError.userIdNil}
        
        let snapshot = try await firestoreService.getUserDocument(uid: userId)
        
        let user = try snapshot.decodeData(as: User.self)
        
        self.currentUser = user
    }
    
    func updateCurrentUser() async {
        
        do {
            guard let uid = self.currentUser?.id else { return }
            
            let snapshot = try await firestoreService.getUserDocument(uid: uid)
            
            let updatedUser = try snapshot.decodeData(as: User.self)
            
            self.currentUser = updatedUser
            
        } catch {
            print("ERROR UPDATE Current User: \(error.localizedDescription)")
        }
    }
}
