//
//  ProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    
    let user: User
    @Binding var isChange: Bool
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var container: DIContainer
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    init(user: User, isChange: Binding<Bool>,
         viewModelBilder: @escaping () -> ProfileViewModel = {
        ProfileViewModel(
            subscription: SubscribeOrUnsubscribe(
                followServise: FollowService()),
            followService: FollowsDeleteByUser(),
            blockService: BlockService(
                serviceCreate: FirestoreGeneralServiceCreate())
        )
    }) {
        self.user = user
        self._isChange = isChange
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    ProfileHeaderFactory.make(user: user)
                    
                    HStack {
                        
                        if container.blockService
                            .blocksId.contains(user.id) {
                            
                            Text("Blocked")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 32)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 22.0))
                            
                        } else {
                            
                            Spacer()
                            
                            if user.id != container.currentUserService.currentUser?.id {
                                
                                Button {
                                    
                                    if container.userFollow.isFollowingCurrentUser(uid: user.id) {
                                        viewModel.unfollow(user: user,
                                                           followers: container.userFollow.followersCurrentUsers)
                                    } else {
                                        viewModel.follow(
                                            user: user,
                                            blockers: container
                                                .blockService.blocksId,
                                            currentUserId: container
                                                .currentUserService
                                                .currentUser?.id)
                                    }
                                    isChange.toggle()
                                    dismiss()
                                    
                                } label: {
                                    
                                    Text(container.userFollow.isFollowingCurrentUser(uid: user.id) ? "Unfollow" : "Follow")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, minHeight: 32)
                                        .background(.black)
                                        .cornerRadius(11)
                                }
                                .disabled(!container
                                    .blockService
                                    .blocksId
                                    .contains(user.id))
                            }
                            
                            Spacer()
                            
                            if let isPrivate = user.isPrivateProfile, isPrivate {
                                
                                Text("Private Profile")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 32)
                                    .background(.black)
                                    .cornerRadius(11)
                                
                            } else {
                                
                                NavigationLink {
                                    UserLocationsView(userId: user.id)
                                } label: {
                                    Text("Map")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, minHeight: 32)
                                        .background(.black)
                                        .cornerRadius(11)
                                }
                                
                            }
                            
                            Spacer()
                            
                        }
                    }
                    .padding()
                    .frame(height: 39)
                    .modifier(CornerRadiusModifier())
                    .padding()
                    
                    if !container.blockService
                        .blocksId.contains(user.id) {
                        
                        UserContentListView(user: user)
                        
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Menu {
                        
                        Button {
                            
                            viewModel.checkAndHandleBlock(
                                userId: user.id,
                                blockers: container
                                    .blockService.blockedsId,
                                currentUser: container
                                    .currentUserService
                                    .currentUser
                            )
                            
                        } label: {
                            
                            if container.blockService.blockedsId.contains(user.id) {
                                Label("Unblock", systemImage: "person.fill.checkmark")
                            } else {
                                Label("Block", systemImage: "person.fill.xmark")
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        
                        ReportButtonView(object: user)
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.primary)
                    }
                    
                }
            }
            .onAppear {
                
                container.userFollow.updateFollowCounts(for: user.id)
                
            }
            .onChange(of: viewModel.isBloked) {
                
                Task {
                    await container.blockService
                        .fetchBlockers(container
                            .currentUserService.currentUser)
                }
                
            }
        }
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user, isChange: .constant(false))
}
