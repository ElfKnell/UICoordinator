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
    
    var userCreate = AuthCreateService(createUserService: CreateUserFirebase(firestoreService: FirestoreCreateUserService()))
    
    func createUser() async -> Bool {
        print("\(self.email)   \(self.password)")
        let isCreate = await userCreate.createUser(withEmail: self.email, password: self.password, fullname: self.name, username: self.username)
        
        if !isCreate {
            self.errorCreated = userCreate.errorMessage
        }
        
        return isCreate
    }
}
