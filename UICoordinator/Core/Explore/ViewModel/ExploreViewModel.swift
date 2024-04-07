//
//  ExploreViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task {
            try await featchUsers()
        }
    }
    
    @MainActor
    private func featchUsers() async throws {
        self.users = try await UserService.fetchUsers()
    }
}
