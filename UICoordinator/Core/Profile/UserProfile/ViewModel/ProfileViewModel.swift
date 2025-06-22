//
//  ProfileViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import SwiftData

class ProfileViewModel: ObservableObject {
    
    private var userActor: UserDataActor?
    
    private let subscription: SubscribeOrUnsubscribeProtocol // = SubscribeOrUnsubscribe(followServise: FollowService())
    
    init(subscription: SubscribeOrUnsubscribeProtocol) {
        self.subscription = subscription
    }
    
    func follow(user: User, currentUserId: String?) {
        
        Task {
            guard let currentUserId else { return }
            await subscription.subscribed(with: user, currentUserId: currentUserId)
            
            try await ensureActorReady()
            
            let localUser = user.toLocalUser()
            try await userActor?.save(user: localUser)
        }
    }
    
    func unfollow(user: User, followers: [Follow]) {
        
        Task {
            await subscription.unsubcribed(with: user, followersCurrentUsers: followers)
            
            try await ensureActorReady()
            
            if let user = try await userActor?.findUserById(user.id) {
                try await userActor?.delete(user: user)
                
            }
        }
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try ModelContainer(for: LocalUser.self)
            userActor = UserDataActor(container: container)
        }
    }
}
