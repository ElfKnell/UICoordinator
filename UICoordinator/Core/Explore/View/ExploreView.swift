//
//  ExploreView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI
import SwiftData

struct ExploreView: View {
    
    var users: [User]
    @State private var searchText = ""
    @EnvironmentObject var container: DIContainer
    @State var isChange = false
    @State private var isLoading = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                if !isLoading {
                    
                    LazyVStack {
                    
                        ForEach(filteredPeople) { user in
                            
                            NavigationLink {
                                
                                ProfileView(user: user, isChange: $isChange)
                                
                            } label: {
                                
                                VStack {
                                    
                                    UserCellView(user: user)
                                    
                                    Divider()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                } else {
                    LoadingView(width: 300, height: 300)
                }
            }
            .onChange(of: isChange) {
                Task {
                    isLoading = true
                    await container.userFollow.loadFollowersCurrentUser(userId: container.currentUserService.currentUser?.id)
                    isLoading = false
                }
            }
            .navigationTitle("Users Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                Button {
                    Task {
                        isLoading = true
                        await container.userFollow.loadFollowersCurrentUser(userId: container.currentUserService.currentUser?.id)
                        searchText = ""
                        isLoading = false
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                }
            }
        }
    }
    
    private var filteredPeople: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }
}

#Preview {
    ExploreView(users: [])
}
