//
//  ExploreViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import Foundation
import FirebaseCrashlytics

class MainUsersViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var isError = false
    @Published var errorMessage: String? = nil
    
    private let fetchUsers: FetchingUsersServiceProtocol
    
    init(fetchUsers: FetchingUsersServiceProtocol) {
        self.fetchUsers = fetchUsers
    }
    
    @MainActor
    func featchUsers(userId: String?) async {
        
        isError = false
        errorMessage = nil
        
        do {
            
            guard let currentUserId = userId else { return }
            self.users = try await fetchUsers.fetchUsers(withId: currentUserId)
            
        } catch {
            isError = true
            errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
        
    }
}
