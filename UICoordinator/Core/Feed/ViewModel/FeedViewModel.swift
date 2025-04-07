//
//  FeedViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/02/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class FeedViewModel: ObservableObject {
    
    @Published var colloquies = [Colloquy]()
    @Published var isLoading = false
    
    private var fetchLocation = FetchLocationFromFirebase()
    private var followersId: [String] = []
    private let pageSize = 15
    
    func fetchColloquies() async throws {
        
        colloquies.removeAll()
        self.isLoading = true
        ColloquyService.lastDocument = nil
        try await getFolowers()
        try await fetchItems()
        try await fetchUserDataForColloquies()
        self.isLoading = false

    }
    
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
    
    private func getLocation(lid: String) async throws -> Location {
        
        return try await fetchLocation.fetchLocation(withId: lid)
        
    }
    
    private func getFolowers() async throws {
        
        let followersData = UserFollowers()
        try await followersData.fetchFollowers()
        self.followersId = followersData.followers.map { $0.following }
        guard let currentUserId = UserService.shared.currentUser?.id else { return }
        self.followersId.append(currentUserId)

    }
    
    
    func fetchColloquiesNext() async throws {
        
        do {
        
            self.isLoading = true
            try await fetchItems()
            try await fetchUserDataForColloquies()
            self.isLoading = false
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    private func fetchItems() async throws {
        
        let items = try await ColloquyService.fetchColloquies(usersId: followersId, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)

    }
}
