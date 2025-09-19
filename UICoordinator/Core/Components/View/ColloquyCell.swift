//
//  TreadCell.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2024.
//

import SwiftUI

struct ColloquyCell: View {
    
    let colloquy: Colloquy

    @EnvironmentObject var container: DIContainer
    @StateObject var viewModelLike: LikesViewModel
    @State private var showReplieCreate = false
    @State var isChange = false
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top, spacing: 12) {
                
                NavigationLink {
                    
                    if container.currentUserService.currentUser == colloquy.user {
                        CurrentUserProfileView()
                    } else {
                        ProfileView(user: colloquy.user ?? DeveloperPreview.user, isChange: $isChange)
                    }
                    
                } label: {
                    CircularProfileImageView(user: colloquy.user, size: .small)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        
                        NavigationLink {
                            
                            if container.currentUserService.currentUser == colloquy.user {
                                CurrentUserProfileView()
                            } else {
                                ProfileView(user: colloquy.user ?? DeveloperPreview.user, isChange: $isChange)
                            }
                            
                        } label: {
                            Text(colloquy.user?.username ?? "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            Text(colloquy.timestamp.timestampString())
                                .font(.caption)
                                .foregroundStyle(Color(.systemGray3))
                            
                            Menu {
                                
                                ReportButtonView(object: colloquy)
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.gray)
                            }
                            
                        }
                        
                    }
                    
                    HStack {
                        
                        if let name = colloquy.location?.name {
                            NavigationLink {
                                LocationColloquyView(location: colloquy.location ?? DeveloperPreview.location)
                            } label: {
                                Text(name)
                                    .foregroundStyle(.blue)
                            }
                        }
                        
                        Text(colloquy.caption)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                    }
                    
                    HStack(spacing: 16) {
                        
                        Spacer()
                        
                        LikeButtonView(colloquyOrActivity: colloquy, userId: container.currentUserService.currentUser?.id)
                            .environmentObject(viewModelLike)
                        
                        Spacer()
                        
                        Button {
                            showReplieCreate.toggle()
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        if let count = colloquy.repliesCount {
                            Text("\(count)")
                        }
                        
                        Spacer()
                        
                        ShareLink(item: colloquy.caption) {
                            Image(systemName: "paperplane")
                        }
                        
                        Spacer()
                    }
                    .foregroundStyle(.black)
                    .padding(.vertical, 8)
                }
            }
            
            Divider()
            
        }
        .padding([.horizontal, .top])
        .task {
            await viewModelLike.isLike(cid:colloquy.id, currentUserId: container.currentUserService.currentUser?.id)
        }
        .onChange(of: isChange) {
            
            Task {
                
                await container.userFollow.loadFollowersCurrentUser(userId: container.currentUserService.currentUser?.id)
                
            }
            
        }
        .sheet(isPresented: $showReplieCreate) {
            RepliesView(colloquy: colloquy, user: container.currentUserService.currentUser)
        }
    }
}

#Preview {

    ColloquyCellFactory.make(
        colloquy: DeveloperPreview.colloquy
    )
    
}
