//
//  RegistrationViewExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/02/2024.
//

import Foundation

extension RegistrationView: AuthenticationFormProtocol {
    
    var formIsValid: Bool {
        return isValidEmail(registrationModel.email)
        && isPasswordSecure(registrationModel.password)
        && registrationModel.cPassword == registrationModel.password
        && isValidName(registrationModel.name)
        && isValidUsername(registrationModel.username)
        && registrationModel.isLicenseAccepted
    }
}

private func isValidEmail(_ email: String) -> Bool {
    let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

private func isPasswordSecure(_ password: String) -> Bool {
    let passwordRegex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"#
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}

private func isValidUsername(_ username: String) -> Bool {
    let usernameRegex = #"^[A-Za-z0-9_-]+$"#
    return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
}

private func isValidName(_ name: String) -> Bool {
    return !name.isEmpty && name.count <= 50
}
