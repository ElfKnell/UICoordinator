//
//  AuthServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 27/04/2025.
//

import Foundation

@MainActor
protocol AuthServiceProtocol {
    
    var userSession: FirebaseUserProtocol? { get set }
    var errorMessage: String? { get set }
    
    func login(withEmail email: String, password: String) async
    func signOut()
    func checkUserSession() async
    
}
