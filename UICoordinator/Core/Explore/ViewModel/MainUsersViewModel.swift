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
    
    init() {
        Task {
            try await featchUsers()
        }
    }
    
    @MainActor
    private func featchUsers() async throws {
        
        guard let currentUserId = CurrentUserService.sharedCurrent.currentUser?.id else { return }
        self.users = await fetchUsers.fetchUsers(withId: currentUserId)
        
    }
}
