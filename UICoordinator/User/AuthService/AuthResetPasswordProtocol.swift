//
//  AuthResetPasswordProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/05/2025.
//

import Foundation

protocol AuthResetPasswordProtocol {
    func resetPassword(email: String) async throws
}
