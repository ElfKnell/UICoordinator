//
//  UserDataActor.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2025.
//

import Foundation
import SwiftData

actor UserDataActor {
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext

    init(container: ModelContainer) {
        self.modelContainer = container
        self.modelContext = ModelContext(container)
    }

    private func internalSave(user: LocalUser) async throws {
        modelContext.insert(user)
        try modelContext.save()
    }
    
    func delete(user: LocalUser) throws {
        modelContext.delete(user)
        try modelContext.save()
    }

    func findUserById(_ id: String) throws -> LocalUser? {
        let descriptor = FetchDescriptor<LocalUser>( predicate: #Predicate { $0.id == id } )
        return try modelContext.fetch(descriptor).first
    }
    
    func fetchAllUsers() throws -> [LocalUser] {
        let descriptor = FetchDescriptor<LocalUser>()
        return try modelContext.fetch(descriptor)
    }
    
    func deleteAllUsers() throws {
        let allUsers = try fetchAllUsers()
        for user in allUsers {
            modelContext.delete(user)
        }
        try modelContext.save()
    }
    
    func update(user updatedUser: LocalUser) {
        
        do {
            
            guard let existingUser = try findUserById(updatedUser.id) else {
                throw NSError(domain: "UserDataActor", code: 404,
                              userInfo: [NSLocalizedDescriptionKey: "User not found"])
            }
            
            existingUser.username = updatedUser.username
            existingUser.bio = updatedUser.bio
            existingUser.link = updatedUser.link
            existingUser.profileImageURL = updatedUser.profileImageURL
            
            try modelContext.save()
            
        } catch {
            print("ERROR UPDATE LOCAL USER: \(error.localizedDescription)")
        }
    }
}

extension UserDataActor: UserDataActorProtocol {
    nonisolated func save(user: LocalUser) async throws {
        try await self.internalSave(user: user)
    }
}
