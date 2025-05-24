//
//  ResetPasswordExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/05/2025.
//

import Foundation

extension ResetPasswordView: AuthenticationFormProtocol {
    
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
    }
}
