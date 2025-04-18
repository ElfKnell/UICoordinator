//
//  LocalUserServiceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/04/2025.
//

import Foundation

protocol LocalUserServiceProtocol {
    func fetchLocalUsers() async -> [LocalUser]
}
