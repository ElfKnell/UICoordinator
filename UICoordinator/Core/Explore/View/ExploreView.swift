//
//  ExploreView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct ExploreView: View {
    
    var users: [User]
    @State private var searchText = ""
    @EnvironmentObject var userFollow: UserFollowers
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                LazyVStack {
                    
                    ForEach(filteredPeople) { user in

                        NavigationLink {
                            
                            ProfileView(user: user)
                            
                        } label: {
                            
                            VStack {
                                
                                UserCellView(user: user)
                                
                                Divider()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Users Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search")
            .onAppear {
                Task {
                    try await userFollow.fetchFollowers()
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
