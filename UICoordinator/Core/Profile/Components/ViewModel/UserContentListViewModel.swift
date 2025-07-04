//
//  UserContentListViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/03/2024.
//

import Foundation

class UserContentListViewModel: ObservableObject {
    
    @Published var colloquies = [Colloquy]()
    @Published var replies = [Colloquy]()
    @Published var isLoading = false
    
    private let fetchColloquies: FetchColloquiesProtocol
    private let fetchReplies: FetchRepliesProtocol
    private let localUserServise: LocalUserServiceProtocol
    private let pageSize = 10
    
    let user: User
    
    init(user: User,
         fetchColloquies: FetchColloquiesProtocol,
         fetchReplies: FetchRepliesProtocol,
         localUserServise: LocalUserServiceProtocol) {
        
        self.fetchColloquies = fetchColloquies
        self.fetchReplies = fetchReplies
        self.localUserServise = localUserServise
        self.user = user
        
        Task {
            await loadDate(currentUser: user)
        }
    }
    
    @MainActor
    func loadDate(currentUser: User?) async {
        
        self.isLoading = true
        
        fetchColloquies.reload()
        fetchReplies.reload()
        self.colloquies.removeAll()
        self.replies.removeAll()
        
        await fetchColloquies()
        await fetchReplies(currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchColloquies() async {
        
        let items = await fetchColloquies.getUserColloquies(user: user, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)
        
    }
    
    @MainActor
    func fetchColloquiesNext() async {
        
        self.isLoading = true
        
        await fetchColloquies()
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchReplies(currentUser: User?) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        let items = await fetchReplies.getReplies(userId: user.id, localUsers: users, pageSize: pageSize)
        self.replies.append(contentsOf: items)
    
    }

    @MainActor
    func fetchNextReplies(currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchReplies(currentUser: currentUser)
        
        self.isLoading = false
        
    }
}
