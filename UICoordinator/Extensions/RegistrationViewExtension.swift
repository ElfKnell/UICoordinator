//
//  RegistrationViewExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import Foundation

extension RegistrationView: AuthenticationFormProtocol {
    
    var formIsValid: Bool {
        return !registrationModel.email.isEmpty
        && registrationModel.email.contains("@")
        && !registrationModel.password.isEmpty
        && registrationModel.password.count > 5
        && registrationModel.cPassword == registrationModel.password
        && !registrationModel.name.isEmpty
        && !registrationModel.username.isEmpty
    }
}
