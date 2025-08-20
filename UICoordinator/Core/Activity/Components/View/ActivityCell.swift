//
//  ActivityCell.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/07/2024.
//

import SwiftUI

struct ActivityCell: View {
    
    let activity: Activity
    
    @Binding var isDelete: Bool
    @Binding var isUpdate: Bool
    
    @StateObject var viewModel: ActivityCellViewModel
    @StateObject var viewModelLike: LikesViewModel
    
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            if let user = activity.spreadUser {
                HStack {
                    CircularProfileImageView(user: user, size: .xSmall)
                        .padding(.top, 8)
                    
                    VStack {
                        Text(user.fullname)
                            .font(.footnote)
                            .fontWeight(.bold)
                        
                        Text(user.username)
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text("Spread")
                    
                    Image(systemName: "arrow.turn.right.down")
                        .foregroundStyle(.green)
                    
                    Spacer()
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: activity.user, size: .small)
                    .padding(.top, 8)
            
                VStack(alignment: .leading, spacing: 4) {
                    
                    NavigationLink {
                        
                        if viewModel.isCurrentUser(activity.ownerUid, currentUser: container.currentUserService.currentUser) {
                            
                            ActivityMapEditView(activity: activity)
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
                        
                        if activity.user != container.currentUserService.currentUser {
                            if viewModel.isStread {
                                Image(systemName: "arrowshape.bounce.forward.fill")
                                    .foregroundStyle(.green)
                            } else {
                                Button {
                                    
                                    Task {
                                        await viewModel.spreadActivity(activity, userId: container.currentUserService.currentUser?.id)
                                    }
                                } label: {
                                    Image(systemName: "arrowshape.bounce.forward")
                                }
                            }
                        }
                        
                        LikeButtonView(colloquyOrActivity: activity, userId: container.currentUserService.currentUser?.id)
                            .environmentObject(viewModelLike)
                        
                        Button {
                            viewModel.showReplies.toggle()
                        } label: {
                            Image(systemName: "bubble.right")
                        }
                        
                        if let count = activity.repliesCount {
                            Text("\(count)")
                        }
                        
                        if viewModel.isCurrentUser(activity.ownerUid, currentUser: container.currentUserService.currentUser) {
                            
                            Button {
                                viewModel.isRemove = true
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
            .alert("Delete activity?", isPresented: $viewModel.isRemove) {
                
                Button("Cancel", role: .cancel) {
                    viewModel.isRemove = false
                }
                
                Button("Delete") {
                    Task {
                        isDelete = true
                        
                        await viewModel.deleteActivity(activity: activity)
                        
                        isDelete = false
                        viewModel.isRemove = false
                        isUpdate.toggle()
                        
                    }
                }
            } message: {
                Text("Once this activity is deleted, it cannot be restored. Are you sure you want to continue?")
            }

            
            Divider()
            
        }
        .padding([.horizontal, .top])
        .padding(.horizontal, viewModel.isLandscape ? 21 : 1)
        .task {
            
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                viewModel.isLandscape = UIDevice.current.orientation.isLandscape
            }
            
            viewModel.isStread(activity,
                                  user: container.currentUserService.currentUser)
            
            await viewModelLike.isLike(cid: activity.id, currentUserId: container.currentUserService.currentUser?.id)
            
        }
        .sheet(isPresented: $viewModel.showReplies, content: {
            ActivityRepliesView(activity: activity, user: container.currentUserService.currentUser)
        })
    }
}

#Preview {
    
    ActivityCellFactory.make(activity: DeveloperPreview.activity, isDelete: .constant(false), isUpdate: .constant(false))

}
