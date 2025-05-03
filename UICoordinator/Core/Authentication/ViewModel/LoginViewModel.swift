//
//  LoginViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI
import Observation

@Observable
class LoginViewModel{
    
    var email = ""
    var password = ""
    var isLoginError = false
    var isCreatedUser = false
}
