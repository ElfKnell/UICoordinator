//
//  TreadCell.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2024.
//

import SwiftUI

struct ColloquyCell: View {
    let colloquy: Colloquy
    @EnvironmentObject var userFollow: UserFollowers
    @StateObject var viewModel = LikesViewModel(collectionName: "Likes")
    @State private var showReplieCreate = false
    @State var isChange = false
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top, spacing: 12) {
                
                NavigationLink {
                    
                    if UserService.shared.currentUser == colloquy.user {
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
                            
                            if UserService.shared.currentUser == colloquy.user {
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
                        
                        Text(colloquy.timestamp.timestampString())
                            .font(.caption)
                            .foregroundStyle(Color(.systemGray3))
                        
                        NavigationLink {
                            RepliesView(colloquy: colloquy)
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(Color(.darkGray))
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
                        
                        Button {
                            Task {
                                await viewModel.doLike(userId: colloquy.ownerUid, likeToObject: colloquy)
                            }
                        } label: {
                            if viewModel.likeId == nil {
                                Image(systemName: "heart")
                            } else {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        if colloquy.likes > 0 {
                            Text("\(colloquy.likes)")
                        }
                        
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
        .onAppear {
            Task {
                await viewModel.isLike(cid:colloquy.id)
            }
        }
        .onChange(of: isChange) {
            
            Task {
                
                await userFollow.setFollowersCurrentUser(userId: UserService.shared.currentUser?.id)
                
            }
            
        }
        .sheet(isPresented: $showReplieCreate, content: {
            CreateColloquyView(colloquy: colloquy)
        })
    }
}

#Preview {
    ColloquyCell(colloquy: DeveloperPreview.colloquy)
}
