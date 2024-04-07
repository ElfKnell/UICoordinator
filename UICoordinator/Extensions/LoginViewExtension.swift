//
//  LoginViewExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import Foundation

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !loginModel.email.isEmpty
        && loginModel.email.contains("@")
        && !loginModel.password.isEmpty
        && loginModel.password.count > 5
    }
}
