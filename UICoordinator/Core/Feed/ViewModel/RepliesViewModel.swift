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
    @Published var isLoading = false
    
    private var pageSize = 20
    private var fetchRepliesFirebase = FetchRepliesFirebase()
    private var localUserServise = LocalUserService()
    
    init(_ cid: String, currentUser: User?) {
        Task {
            await fetchRepliesRefresh(cid, currentUser: currentUser)
        }
    }
    
    func fetchReplies(_ cid: String, currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchRepliesData(cid: cid, currentUser: currentUser)
        
        self.isLoading = false
    }
    
    
    func fetchRepliesRefresh(_ cid: String, currentUser: User?) async {
        
        self.isLoading = true
        
        fetchRepliesFirebase = FetchRepliesFirebase()
        self.replies.removeAll()
        await fetchRepliesData(cid: cid, currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    func fetchRepliesData(cid: String, currentUser: User?) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        let items = await fetchRepliesFirebase.getReplies(colloquyId: cid, localUsers: users, pageSize: pageSize)
        self.replies.append(contentsOf: items)

    }

}
