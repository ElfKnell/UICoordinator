//
//  AuthProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation
import Firebase

protocol AuthProtocol {
    var currentUser: (any AuthUserProtocol)? { get }
}
