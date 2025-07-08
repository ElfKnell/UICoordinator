//
//  AuthProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResultProtocol?
}
