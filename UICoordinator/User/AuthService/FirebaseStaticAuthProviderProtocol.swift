//
//  FirebaseStaticAuthProviderProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/07/2025.
//

import Foundation

protocol FirebaseStaticAuthProviderProtocol {
    var currentUser: FirebaseUserProtocol? { get }
    func signOut() throws
}
