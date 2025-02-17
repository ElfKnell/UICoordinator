//
//  FeedViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/02/2024.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var colloquies = [Colloquy]()
    
    init() {
        Task {
            try await fetchColloquies()
        }
    }
    
    func fetchColloquies() async throws {
        self.colloquies = try await getColloquesByUsers()
        self.colloquies.removeAll(where: {$0.ownerColloquy != nil})
        try await fetchUserDataForColloquies()
        try await fetchLocationDataForColloquies()
    }
    
    private func fetchUserDataForColloquies() async throws {
        
        for i in 0 ..< colloquies.count
        {
            let colloquy = colloquies[i]
            let ownerUid = colloquy.ownerUid
            let colloquyUser = try await UserService.fetchUser(withUid: ownerUid)
            
            colloquies[i].user = colloquyUser
        }
    }
    
    private func fetchLocationDataForColloquies() async throws {
        for i in 0 ..< colloquies.count
        {
            let colloquy = colloquies[i]
            guard let lid = colloquy.locationId else { continue }
            let colloquyLocation = try await getLocation(lid: lid)
            
            colloquies[i].location = colloquyLocation
        }
    }
    
    private func getLocation(lid: String) async throws -> Location {
        return try await LocationService.fetchLocation(withLid: lid)
    }
    
    private func getColloquesByUsers() async throws -> [Colloquy] {
        let followersData = UserFollowers()
        try await followersData.fetchFollowers()
        let followers = followersData.followers
        guard let currentUserId = UserService.shared.currentUser?.id else { return []}
        
        var colloquies = try await ColloquyService.fetchUserColloquy(uid: currentUserId)
        
        for follower in followers {
            let col = try await ColloquyService.fetchUserColloquy(uid: follower.following)
            
            colloquies += col
        }
        
        return colloquies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
