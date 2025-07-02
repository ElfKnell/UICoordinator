//
//  AuthCreateServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/04/2025.
//

import Foundation

protocol AuthCreateServiceProtocol {
    
    func createUser(withEmail email: String,
                    password: String,
                    fullname: String,
                    username: String) async throws
}
