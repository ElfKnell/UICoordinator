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
    
    private var fetchColloquies = FetchColloquiesFirebase()
    private var fetchReplies = FetchRepliesFirebase()
    private var localUserServise = LocalUserService()
    private var pageSize = 10
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func loadDate() async {
        
        self.isLoading = true
        
        fetchColloquies = FetchColloquiesFirebase()
        fetchReplies = FetchRepliesFirebase()
        self.colloquies.removeAll()
        self.replies.removeAll()
        
        await fetchColloquies()
        await fetchReplies()
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchColloquies() async {
        
        let items = await fetchColloquies.getUserColloquies(user: user, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)
        
    }
    
    @MainActor
    func fetchColloquiesNext() async throws {
        
        self.isLoading = true
        
        await fetchColloquies()
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchReplies() async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers()
        let items = await fetchReplies.getReplies(userId: user.id, localUsers: users, pageSize: pageSize)
        self.replies.append(contentsOf: items)
    
    }

    @MainActor
    func fetchNextReplies() async {
        
        self.isLoading = true
        
        await fetchReplies()
        
        self.isLoading = false
        
    }
}
