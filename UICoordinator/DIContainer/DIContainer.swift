//
//  DIContainer.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 27/04/2025.
//

import Foundation
import SwiftData

@MainActor
final class DIContainer: ObservableObject {
    
    var authService: AuthServiceProtocol
    var currentUserService: CurrentUserServiceProtocol
    
    let userFollow: UserFollowersProtocol
    var networkMonitor: ReachabilityProtocol
    
    init() {
        
        let firestoreService = FirestoreService()
        let authProvider = FirebaseAuthProvider()
        let staticAuthProvider = FirebaseStaticAuthProvider()
    
        self.currentUserService = CurrentUserService(firestoreService: firestoreService)
        self.authService = AuthService(currentUserService: self.currentUserService,
                                       authProvider: authProvider,
                                       authStaticProvider: staticAuthProvider)
        
        let fetchingService = FetchingFollowAndFollowCount(firestoreService: FirestoreFollowService())
        let checkedFollowing = CheckedLocalUsersByFollowing(localUserService: LocalUserService(),
                                                            userService: UserService(),
                                                            containerProvider: { try ModelContainer(for: LocalUser.self) })
        
        self.userFollow = UserFollowers(fetchingService: fetchingService,
                                        checkedFollowing: checkedFollowing)
        
        self.networkMonitor = NetworkMonitor()
    }
}

