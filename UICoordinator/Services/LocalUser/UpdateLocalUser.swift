//
//  UpdateLocalUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/04/2025.
//

import SwiftData
import Foundation

class UpdateLocalUser: UpdateLocalUserProtocol {
    
    private var userActor: UserDataActor?
    
    func updateLocalUser(user updatedUser: LocalUser) async {
        
        do {
            
            try await ensureActorReady()
            
            await userActor?.update(user: updatedUser)
            
        } catch {
            print("ERROR update local user (actor ready): \(error.localizedDescription)")
        }
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try ModelContainer(for: LocalUser.self)
            userActor = UserDataActor(container: container)
        }
    }
}
