//
//  RepliesViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2024.
//

import Foundation

@MainActor
class RepliesViewModel: ObservableObject {
    
    @Published var replies = [Colloquy]()
    
    func fitchReplies(cid: String) async throws {
        self.replies = try await ColloquyService.fetchReplies(with: cid)
        try await fetchUserDataForColloquies()
        try await fetchLocationDataForColloquies()
    }
    
    private func fetchUserDataForColloquies() async throws {
        
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            let ownerUid = colloquy.ownerUid
            let colloquyUser = try await UserService.fetchUser(withUid: ownerUid)
            
            replies[i].user = colloquyUser
        }
    }
    
    private func fetchLocationDataForColloquies() async throws {
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            guard let lid = colloquy.locationId else { continue }
            let colloquyLocation = try await getLocation(lid: lid)
            
            replies[i].location = colloquyLocation
        }
    }
    
    private func getLocation(lid: String) async throws -> Location {
        return try await LocationService.fetchLocation(withLid: lid)
    }
}
