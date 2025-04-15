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
    
    private var fetchLocation = FetchLocationFromFirebase()
    
    func fitchReplies(cid: String) async throws {
        self.replies = try await ColloquyService.fetchReplies(with: cid)
        await fetchUserDataForColloquies()
        await fetchLocationDataForColloquies()
    }
    
    private func fetchUserDataForColloquies() async {
        
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            let ownerUid = colloquy.ownerUid
            let colloquyUser = await UserService.fetchUser(withUid: ownerUid)
            
            replies[i].user = colloquyUser
        }
    }
    
    private func fetchLocationDataForColloquies() async {
        
        for i in 0 ..< replies.count
        {
            let colloquy = replies[i]
            guard let lid = colloquy.locationId else { continue }
            let colloquyLocation = await getLocation(lid: lid)
            
            replies[i].location = colloquyLocation
        }
    }
    
    private func getLocation(lid: String) async -> Location {
        return await fetchLocation.fetchLocation(withId: lid)
    }
}
