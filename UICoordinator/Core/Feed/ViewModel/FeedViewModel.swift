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
        self.colloquies = try await ColloquyService.fetchColloquies()
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
    
    func getLocation(lid: String) async throws -> Location {
        return try await LocationService.fetchLocation(withLid: lid)
    }
}
