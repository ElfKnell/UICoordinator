//
//  RepliesViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2024.
//

import Foundation

class RepliesViewModel: ObservableObject {
    
    @Published var replies = [Colloquy]()
    @Published var isLoading = false
    
    let isOrdering: Bool
    private let pageSize = 20
    private let fetchRepliesFirebase: FetchRepliesProtocol
    private let localUserServise: LocalUserServiceProtocol
    
    init(_ cid: String, currentUser: User?, isOrdering: Bool,
         fetchRepliesFirebase: FetchRepliesProtocol,
         localUserServise: LocalUserServiceProtocol) {
        
        self.isOrdering = isOrdering
        self.fetchRepliesFirebase = fetchRepliesFirebase
        self.localUserServise = localUserServise
        Task {
            await fetchRepliesRefresh(cid, currentUser: currentUser)
        }
    }
    
    @MainActor
    func fetchReplies(_ cid: String, currentUser: User?) async {
        
        self.isLoading = true
        
        await fetchRepliesData(cid: cid, currentUser: currentUser)
        
        self.isLoading = false
    }
    
    @MainActor
    func fetchRepliesRefresh(_ cid: String, currentUser: User?) async {
        
        self.isLoading = true
        
        fetchRepliesFirebase.reload()
        self.replies.removeAll()
        await fetchRepliesData(cid: cid, currentUser: currentUser)
        
        self.isLoading = false
        
    }
    
    @MainActor
    func fetchRepliesData(cid: String, currentUser: User?) async {
        
        let users = await localUserServise.fetchUsersbyLocalUsers(currentUser: currentUser)
        let items = await fetchRepliesFirebase.getReplies(colloquyId: cid, localUsers: users, pageSize: pageSize, ordering: isOrdering)
        self.replies.append(contentsOf: items)

    }

}
