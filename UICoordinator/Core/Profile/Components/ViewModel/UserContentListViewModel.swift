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
    
    private var fetchLocation = FetchLocationFromFirebase()
    private var pageSize = 10
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func fetchUserColloquies() async throws {
        
        self.isLoading = true
        ColloquyService.lastDocument = nil
        self.colloquies.removeAll()
        self.replies.removeAll()
        
        try await fetchItems()
        
        if !self.colloquies.isEmpty {
            try await fetchUserDataForColloquies()
        }
        self.isLoading = false

    }
    
    @MainActor
    func fetchUserReplies() async throws {
        ColloquyService.lastDocument = nil
        self.colloquies.removeAll()
        self.replies.removeAll()
        
        try await fetchReplies()
        if !self.replies.isEmpty {
            try await fetchUserDataForReplies()
        }
    }
    
    @MainActor
    private func fetchUserDataForColloquies() async throws {
        
        do {
            for i in 0 ..< colloquies.count
            {
                let colloquy = colloquies[i]
                let ownerUid = colloquy.ownerUid
                let colloquyUser = try await UserService.fetchUser(withUid: ownerUid)
                
                colloquies[i].user = colloquyUser
                
                guard let lid = colloquy.locationId else { continue }
                let colloquyLocation = try await getLocation(lid: lid)
                
                colloquies[i].location = colloquyLocation
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    private func fetchUserDataForReplies() async throws {
        
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            let ownerUid = colloquy.ownerUid
            let colloquyUser = try await UserService.fetchUser(withUid: ownerUid)
            
            replies[i].user = colloquyUser
            
            guard let lid = colloquy.locationId else { continue }
            let colloquyLocation = try await getLocation(lid: lid)
            
            replies[i].location = colloquyLocation
        }
        
    }
    
    private func getLocation(lid: String) async throws -> Location {
        
        return try await fetchLocation.fetchLocation(withId: lid)
        
    }
    
    @MainActor
    private func fetchItems() async throws {
        
        let items = try await ColloquyService.fetchUserColloquy(uid: user.id, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)
        
    }
    
    @MainActor
    func fetchColloquiesNext() async throws {
        
        do {
        
            self.isLoading = true
            try await fetchItems()
            try await fetchUserDataForColloquies()
            self.isLoading = false
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    @MainActor
    private func fetchReplies() async throws {
        
        let items = try await ColloquyService.fetchUserColloquyHasReplies(uid: user.id, pageSize: pageSize)
        self.replies.append(contentsOf: items)
        
    }

    @MainActor
    func fetchNextReplies() async throws {
        
        do {
        
            self.isLoading = true
            try await fetchReplies()
            try await fetchUserDataForReplies()
            self.isLoading = false
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
}
