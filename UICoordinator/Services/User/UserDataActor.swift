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

    func save(user: LocalUser) throws {
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
}
