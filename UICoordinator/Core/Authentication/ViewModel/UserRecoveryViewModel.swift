//
//  UserRecoveryViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/07/2025.
//

import Foundation

class UserRecoveryViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var isError = false
    
    let userRecovery: UserRecoveryServiceProtocol
    
    init(userRecovery: UserRecoveryServiceProtocol) {
        self.userRecovery = userRecovery
    }
    
    func restore(_ userId: String?) async throws {
        
        try await userRecovery.recovery(userId)
    }
}
