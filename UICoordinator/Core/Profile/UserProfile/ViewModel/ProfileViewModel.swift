//
//  ProfileViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import FirebaseCrashlytics
import SwiftData

class ProfileViewModel: ObservableObject {
    
    @Published var isBloked = false
    
    private var userActor: UserDataActor?
    
    private let subscription: SubscribeOrUnsubscribeProtocol
    private let followService: FollowsDeleteByUserProtocol
    private let blockService: BlockServiceProtocol
    
    init(subscription: SubscribeOrUnsubscribeProtocol,
         followService: FollowsDeleteByUserProtocol,
         blockService: BlockServiceProtocol) {
        
        self.subscription = subscription
        self.followService = followService
        self.blockService = blockService
        
    }
    
    func follow(user: User, blockers: Set<String>, currentUserId: String?) {
        
        Task {
            
            guard !blockers.contains(user.id) else { return }
            
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
    
    @MainActor
    func checkAndHandleBlock(userId: String, blockers: Set<String>, currentUser: User?) {
        
        Task {
            
            if blockers.contains(userId) {
                await unblockUser(userId: userId, currentUser: currentUser)
            } else {
                await blockUser(userId: userId, currentUser: currentUser)
            }
            
            isBloked.toggle()
        }
    }
    
    private func ensureActorReady() async throws {
        if userActor == nil {
            let container = try ModelContainer(for: LocalUser.self)
            userActor = UserDataActor(container: container)
        }
    }
    
    private func blockUser(userId: String, currentUser: User?) async {
        
        do {
            
            guard let currentUserId = currentUser?.id else {
                throw UserError.userIdNil
            }
            
            try await self.followService
                .deleteFollowRelationship(curentUserId: currentUserId, userId: userId)
            
            try await self.blockService
                .uploadeBlock(curentUserIs: currentUserId, userId: userId)
            
        } catch {
            Crashlytics.crashlytics()
                .setCustomValue(currentUser?.id ?? "none", forKey: "current_user_id")
            Crashlytics.crashlytics()
                .setCustomValue(userId, forKey: "user_id")
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    private func unblockUser(userId: String, currentUser: User?) async {
        
        do {
            
            guard let currentUserId = currentUser?.id else {
                throw UserError.userIdNil
            }
            
            try await self.blockService
                .deleteBlock(curentUserIs: currentUserId, userId: userId)
            
        } catch {
            Crashlytics.crashlytics()
                .setCustomValue(currentUser?.id ?? "none", forKey: "current_user_id")
            Crashlytics.crashlytics()
                .setCustomValue(userId, forKey: "user_id")
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    
}
