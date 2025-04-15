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
    @Published var isCreateUserError = false
    
}
