//
//  FeedViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/02/2024.
//

import SwiftUI
import Firebase
import SwiftData

@MainActor
class FeedViewModel: ObservableObject {
    
    private var localUserServise = LocalUserService()
    
    @Published var colloquies = [Colloquy]()
    @Published var isLoading = false
    
    private var fetchColloquiesFromFirebase = FetchColloquiesFirebase()
    private let pageSize = 15
    
    func fetchColloquies(currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchColloquiesFirebase(currentUser: currentUser)
        
        self.isLoading = false
    }
    
    
    func fetchColloquiesRefresh(currentUser: User?) async {
        
        self.isLoading = true
        
        fetchColloquiesFromFirebase = FetchColloquiesFirebase()
        self.colloquies.removeAll()
        await fetchColloquiesFirebase(currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    private func fetchColloquiesFirebase(currentUser: User?) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        let items = await fetchColloquiesFromFirebase.getColloquies(users: users, pageSize: pageSize)
        self.colloquies.append(contentsOf: items)

    }
}
