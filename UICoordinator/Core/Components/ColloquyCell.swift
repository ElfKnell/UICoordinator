//
//  TreadCell.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/02/2024.
//

import SwiftUI

struct ColloquyCell: View {
    let colloquy: Colloquy
    @StateObject var viewModel = LikesViewModel(collectionName: "Likes")
    @State private var showReplieCreate = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: colloquy.user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(colloquy.user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
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
                        Button {
                            Task {
                                try await viewModel.doLike(userId: colloquy.ownerUid, colloquyId: colloquy.id)
                            }
                        } label: {
                            if viewModel.likeId == nil {
                                Image(systemName: "heart")
                            } else {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Button {
                            showReplieCreate.toggle()
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                    .foregroundStyle(.black)
                    .padding(.vertical, 8)
                }
            }
            
            Divider()
            
        }
        .padding()
        .onAppear {
            Task {
                try await viewModel.isLike(cid:colloquy.id)
            }
        }
        .sheet(isPresented: $showReplieCreate, content: {
            CreateColloquyView(location: nil, colloquy: colloquy)
        })
    }
}

#Preview {
    ColloquyCell(colloquy: DeveloperPreview.colloquy)
}
