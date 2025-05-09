//
//  ColloquyCellForCurrentUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/05/2025.
//

import SwiftUI

struct ColloquyCellForCurrentUser: View {
    
    let colloquy: Colloquy
    let user: User
    let colloquyService = ColloquyService(serviceDetete: FirestoreGeneralDeleteService(), repliesFetchingService: FetchRepliesFirebase())
    @Binding var isDeleted: Bool
    @StateObject var viewModel = LikesViewModel(collectionName: .likes)
    @State private var sheetStatus: SheetStatus? = nil
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        
                        Text(user.username)
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(colloquy.timestamp.timestampString())
                            .font(.caption)
                            .foregroundStyle(Color(.systemGray3))
                        
                        Button {
                            Task {
                                await colloquyService.markForDelete(colloquy.id)
                                isDeleted.toggle()
                            }
                        } label: {
                            Image(systemName: "trash.circle")
                                .foregroundStyle(.red)
                                .font(.title2)
                        }
                        
                    }
                    
                    HStack {
                        if let name = colloquy.location?.name {
                            Button {
                                sheetStatus = .location
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
                                await viewModel.doLike(userId: colloquy.ownerUid, currentUserId: user.id, likeToObject: colloquy)
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
                            sheetStatus = .reply
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
                await viewModel.isLike(cid: colloquy.id, currentUserId: user.id)
            }
        }
        .sheet(item: $sheetStatus) { status in
            switch status {
            case .reply:
                RepliesView(colloquy: colloquy, user: user)
            case .location:
                LocationColloquyView(location: colloquy.location ?? DeveloperPreview.location)
            }
        }
    }
}

#Preview {
    ColloquyCellForCurrentUser(colloquy: DeveloperPreview.colloquy,
                               user: DeveloperPreview.user,
                               isDeleted: .constant(false))
}
