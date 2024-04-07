//
//  UserContentListViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 01/03/2024.
//

import Foundation

class UserContentListViewModel: ObservableObject {
    
    @Published var colloquies = [Colloquy]()
    
    let user: User
    
    init(user: User) {
        self.user = user
        Task {
            try await fetchUserColloquies()
        }
    }
    
    @MainActor
    func fetchUserColloquies() async throws {
        var colloquies = try await ColloquyService.fetchUserColloquy(uid: user.id)
        
        for i in 0 ..< colloquies.count {
            colloquies[i].user = self.user
            guard let lid = colloquies[i].locationId else { continue }
            let colloquyLocation = try await LocationService.fetchLocation(withLid: lid)
            colloquies[i].location = colloquyLocation
        }
        
        self.colloquies = colloquies
    }
}
