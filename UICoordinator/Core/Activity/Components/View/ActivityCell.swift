//
//  ActivityCell.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/07/2024.
//

import SwiftUI

struct ActivityCell: View {
    
    let activity: Activity
    @StateObject var viewModelLike = LikesViewModel(collectionName: "ActivityLikes")
    @StateObject var viewModel = ActivityCellViewModel()
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @Binding var isDelete: Bool
    @Binding var isUpdate: Bool
    @State private var showReplies = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: activity.user, size: .small)
                    .padding(.top, 8)
            
                VStack(alignment: .leading, spacing: 4) {
                    
                    NavigationLink {
                        
                        if ActivityCurrentUser.isCurrentUser(activity.ownerUid) {
                            
                            ActivityEditView(activity: activity)
                                .onDisappear {
                                    isUpdate.toggle()
                                }
                            
                        } else {
                            
                            ActivityMapVisionView(activity: activity)
                            
                        }
                        
                    } label: {
                        VStack {
                            HStack {
                                
                                Text(activity.user?.username ?? "")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Text(activity.time.timestampString())
                                    .font(.caption)
                                    .foregroundStyle(Color(.systemGray3))
                                
                            }
                            
                            HStack {
                                
                                Text(activity.name)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("^[\(activity.locationsId.count) location](inflect: true)")
                                    .font(.footnote)
                                
                            }
                        }
                    }

                    HStack(spacing: 8) {
                        
                        Text(activity.typeActivity.description)
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModelLike.doLike(userId: activity.ownerUid, likeToObject: activity)
                                
                                isUpdate.toggle()
                            }
                        } label: {
                            if viewModelLike.likeId == nil {
                                Image(systemName: "heart")
                            } else {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        Button {
                            showReplies.toggle()
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        if let count = activity.repliesCount {
                            Text("\(count)")
                        }
                        
                        if ActivityCurrentUser.isCurrentUser(activity.ownerUid) {
                            
                            Button {
                                Task {
                                    isDelete = true
                                    
                                    try await viewModel.deleteActivity(activity: activity)
                                    
                                    isDelete = false
                                    
                                    isUpdate.toggle()
                                }
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            
            Divider()
            
        }
        .padding([.horizontal, .top])
        .padding(.horizontal, isLandscape ? 21 : 1)
        .onAppear {
            
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                isLandscape = UIDevice.current.orientation.isLandscape
            }
            
            Task {
                await viewModelLike.isLike(cid: activity.id)
            }
            
        }
        .sheet(isPresented: $showReplies, content: {
            ActivityRepliesView(activity: activity)
        })
    }
}

#Preview {
    ActivityCell(activity: DeveloperPreview.activity, isDelete: .constant(false), isUpdate: .constant(false))
}
