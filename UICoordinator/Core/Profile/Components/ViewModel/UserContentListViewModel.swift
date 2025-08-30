//
//  UserContentListViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/03/2024.
//

import Foundation
import FirebaseCrashlytics

class UserContentListViewModel: ObservableObject {
    
    @Published var colloquies = [Colloquy]()
    @Published var replies = [Colloquy]()
    @Published var isLoading = false
    @Published var isError = false
    @Published var messageError: String?
    
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
        
    }
    
    @MainActor
    func startLoadColloquies() async {
        
        self.isLoading = true
        
        fetchColloquies.reload()
        self.colloquies.removeAll()
        await fetchColloquies()
        
        self.isLoading = false
    }
    
    @MainActor
    func startReplies(currentUser: User?) async {
        
        self.isLoading = true
        
        fetchReplies.reload()
        self.replies.removeAll()
        await fetchReplies(currentUser: currentUser)
        
        self.isLoading = false
    }
    
    @MainActor
    func fetchColloquiesNext() async {
        
        self.isLoading = true
        
        await fetchColloquies()
        
        self.isLoading = false
        
    }
    

    @MainActor
    func fetchNextReplies(currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchReplies(currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchReplies(currentUser: User?) async {
        
        self.isError = false
        self.messageError = nil
        
        do {
            
            let users = try await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
            let items = try await fetchReplies.getReplies(userId: user.id, localUsers: users, pageSize: pageSize)
            self.replies.append(contentsOf: items)
            
        } catch {
            self.isError = true
            self.messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    
    }
    
    @MainActor
    private func fetchColloquies() async {
        
        self.isError = false
        self.messageError = nil
        
        do {
            
            let items = try await fetchColloquies.getUserColloquies(user: user, pageSize: pageSize)
            self.colloquies.append(contentsOf: items)
            
        } catch {
            self.isError = true
            self.messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
}
