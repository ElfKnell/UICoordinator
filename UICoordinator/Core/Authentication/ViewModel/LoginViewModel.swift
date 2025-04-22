//
//  LoginViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoginError = false
    
    @Published var isCreatedUser = false
}
