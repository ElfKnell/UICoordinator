//
//  UserDataActorProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/04/2025.
//

import Foundation

protocol UserDataActorProtocol: AnyObject {
    func save(user: LocalUser) async throws
    
    func delete(user: LocalUser) async throws
    
    func deleteAllUsers() async throws
}
