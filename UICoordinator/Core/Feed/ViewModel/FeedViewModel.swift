//
//  FeedViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/02/2024.
//

import SwiftUI
import Firebase
import SwiftData

class FeedViewModel: ObservableObject {
    
    @Published var colloquies = [Colloquy]()
    @Published var isLoading = false
    
    private let localUserServise: LocalUserServiceProtocol
    private let fetchColloquies: FetchColloquiesProtocol
    private let pageSize = 15
    
    init(localUserServise: LocalUserServiceProtocol,
         fetchColloquies: FetchColloquiesProtocol) {
        
        self.localUserServise = localUserServise
        self.fetchColloquies = fetchColloquies
    }
    
    @MainActor
    func fetchColloquies(currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchColloquiesFirebase(currentUser: currentUser)
        
        self.isLoading = false
    }
    
    @MainActor
    func fetchColloquiesRefresh(currentUser: User?) async {
        
        self.isLoading = true
        
        fetchColloquies.reload()
        self.colloquies.removeAll()
        await fetchColloquiesFirebase(currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    @MainActor
    private func fetchColloquiesFirebase(currentUser: User?) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        let items = await fetchColloquies.getColloquies(users: users, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)

    }
}
