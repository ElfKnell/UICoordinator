//
//  ExploreViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import Foundation

class MainUsersViewModel: ObservableObject {
    @Published var users = [User]()
    
    private let fetchUsers: FetchingUsersServiceProtocol
    
    init(fetchUsers: FetchingUsersServiceProtocol) {
        self.fetchUsers = fetchUsers
    }
    
    @MainActor
    func featchUsers(userId: String?) async {
        
        guard let currentUserId = userId else { return }
        self.users = await fetchUsers.fetchUsers(withId: currentUserId)
        
    }
}
