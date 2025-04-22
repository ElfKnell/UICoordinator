//
//  FirestoreCreateUserProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import Foundation

protocol FirestoreCreateUserProtocol {
    func setUserData(id: String, data: [String: Any]) async throws
}
