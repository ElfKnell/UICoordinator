//
//  FirebaseAuthProviderProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/05/2025.
//

import Foundation

protocol FirebaseAuthProviderProtocol {
    func signIn(email: String, password: String) async throws -> FirebaseUserProtocol
}
