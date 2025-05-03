//
//  ExploreViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import Foundation

class MainUsersViewModel: ObservableObject {
    @Published var users = [User]()
    
    private var fetchUsers = FetchingUsersServiceFirebase(repository: FirestoreUserRepository())
    
    @MainActor
    func featchUsers(userId: String?) async {
        
        guard let currentUserId = userId else { return }
        self.users = await fetchUsers.fetchUsers(withId: currentUserId)
        
    }
}
