//
//  RegistrationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var name = ""
    @Published var password = ""
    @Published var username = ""
    @Published var cPassword = ""
    @Published var errorCreated: String?
    @Published var isCreateUserError = false
    
    private let userCreate: AuthCreateServiceProtocol
    
    init(userCreate: AuthCreateServiceProtocol) {
        self.userCreate = userCreate
    }
    
    @MainActor
    func createUser() async -> Bool {
        
        errorCreated = nil
        isCreateUserError = false
        
        do {
            try await userCreate.createUser(withEmail: self.email, password: self.password, fullname: self.name, username: self.username)
            
            return true
        } catch let userError as UserError {
            errorCreated = userError.description
            isCreateUserError = true
            return false
        } catch {
            errorCreated = error.localizedDescription
            isCreateUserError = true
            return false
        }
    }
}
