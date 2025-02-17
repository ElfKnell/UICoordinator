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
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func fetchUserColloquies() async throws {
        var colloquies = try await ColloquyService.fetchUserColloquy(uid: user.id)
        colloquies.removeAll(where: {$0.ownerColloquy != nil})
        for i in 0 ..< colloquies.count {
            colloquies[i].user = self.user
            guard let lid = colloquies[i].locationId else { continue }
            let colloquyLocation = try await LocationService.fetchLocation(withLid: lid)
            colloquies[i].location = colloquyLocation
        }
        
        self.colloquies = colloquies
    }
    
    @MainActor
    func fetchUserReplies() async throws {
        var colloquies = try await ColloquyService.fetchUserColloquy(uid: user.id)
        colloquies.removeAll(where: {$0.ownerColloquy != nil})
        
        var replies = try await ColloquyService.fetchColloquies()
        replies.removeAll(where: {$0.ownerColloquy == nil})
        
        var repliesColloquies = [Colloquy]()
        var ownerColloquyId = [String]()
        
        for reply in replies {
            ownerColloquyId.append(reply.ownerColloquy!)
        }
        let setReplies = Set(ownerColloquyId)
        
        for colloquy in colloquies {
            if setReplies.contains(colloquy.id) {
                repliesColloquies.append(colloquy)
            }
        }
        
        for i in 0 ..< repliesColloquies.count {
            repliesColloquies[i].user = self.user
            guard let lid = repliesColloquies[i].locationId else { continue }
            let colloquyLocation = try await LocationService.fetchLocation(withLid: lid)
            repliesColloquies[i].location = colloquyLocation
        }
        
        self.replies = repliesColloquies.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}
