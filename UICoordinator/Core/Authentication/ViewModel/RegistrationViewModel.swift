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
        
        let isCreate = await userCreate.createUser(withEmail: self.email, password: self.password, fullname: self.name, username: self.username)
        
        if !isCreate {
            self.errorCreated = userCreate.errorMessage
        }
        
        return isCreate
    }
}
