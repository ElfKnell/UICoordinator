//
//  CreateUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation

protocol CreateUserProtocol {
    func uploadUserData(id: String, withEmail email: String, fullname: String, username: String) async throws
}
