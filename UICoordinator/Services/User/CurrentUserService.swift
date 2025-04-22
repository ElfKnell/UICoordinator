//
//  CurrentUserService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


class CurrentUserService: CurrentUserServiceProtocol {
    
    
    var firestoreService: FirestoreServiceProtocol
    var currentUser: User?
    
    static let sharedCurrent = CurrentUserService(firestoreService: FirestoreService())
    
    init(firestoreService: FirestoreServiceProtocol) {
        
        self.firestoreService = firestoreService
    }
    
    func fetchCurrentUser(userId: String?) async {
        
        do {
            
            if let uid = userId {
                
                let snapshot = try await firestoreService.getUserDocument(uid: uid)
                
                self.currentUser = try snapshot.decodeData(as: User.self)
                
            } else {
                
                self.currentUser = nil
                
            }

        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
    
    func updateCurrentUser() async {
        
        do {
            guard let uid = self.currentUser?.id else { return }
            
            let snapshot = try await firestoreService.getUserDocument(uid: uid)
            
            self.currentUser = try snapshot.decodeData(as: User.self)
            
        } catch {
            print("ERROR UPDATE Current User: \(error.localizedDescription)")
        }
    }
}
