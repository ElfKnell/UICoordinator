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
    @Published var isLicenseAccepted = false
    @Published var isPasswordCorect = false
    @Published var isLoading = false
    @Published var eula = "https://elfknell.github.io/Licenses/eula.html"
    @Published var privacyPolicy = "https://elfknell.github.io/Licenses/privacy_policy.html"
    
    private let userCreate: AuthCreateServiceProtocol
    
    init(userCreate: AuthCreateServiceProtocol) {
        self.userCreate = userCreate
    }
    
    @MainActor
    func createUser() async -> Bool {
        
        errorCreated = nil
        isCreateUserError = false
        isLoading = true
        
        do {
            
            if !isLicenseAccepted {
                throw UserError.userNotAcceptedLicense
            }
            try await userCreate.createUser(withEmail: self.email, password: self.password, fullname: self.name, username: self.username)
            
            isLoading = false
            return true
        } catch let userError as UserError {
            errorCreated = userError.description
            isCreateUserError = true
            isLoading = false
            return false
        } catch {
            errorCreated = error.localizedDescription
            isCreateUserError = true
            isLoading = false
            return false
        }

    }
    
}
