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
    
    func fetchReplies(_ cid: String) async {
        
        self.isLoading = true
        
        await fetchRepliesData(cid: cid)
        
        self.isLoading = false
    }
    
    
    func fetchRepliesRefresh(_ cid: String) async {
        
        self.isLoading = true
        
        fetchRepliesFirebase = FetchRepliesFirebase()
        self.replies.removeAll()
        await fetchRepliesData(cid: cid)
        
        self.isLoading = false
        
    }
    
    func fetchRepliesData(cid: String) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers()
        let items = await fetchRepliesFirebase.getReplies(colloquyId: cid, localUsers: users, pageSize: pageSize)
        self.replies.append(contentsOf: items)

    }

}
