//
//  ResetPasswordViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/05/2025.
//

import Foundation

@Observable
class ResetPasswordViewModel {
    
    var email = ""
    var message = ""
    var processReset: ResetPasswordCheck = .isStart
    
    private let authReset: AuthResetPasswordProtocol
    
    init(authReset: AuthResetPasswordProtocol) {
        self.authReset = authReset
    }
    
    func resetPassword() async {
        do {
            let email = self.email
            try await authReset.resetPassword(email: email)
            message = "Password reset link sent to email - \(email)."
            processReset = .isSuccess
            self.email = ""
        } catch {
            processReset = .isIssue
            message = "Sorry, but you have issue: \(error.localizedDescription)."
        }
    }
}
