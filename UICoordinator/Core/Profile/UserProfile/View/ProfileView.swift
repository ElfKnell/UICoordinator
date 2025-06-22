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
        ProfileViewModel(subscription: SubscribeOrUnsubscribe(followServise: FollowService()))
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
                        
                        Spacer()
                        
                        if user.id != container.currentUserService.currentUser?.id {
                            
                            Button {
                                
                                if container.userFollow.isFollowingCurrentUser(uid: user.id) {
                                    viewModel.unfollow(user: user,
                                                       followers: container.userFollow.followersCurrentUsers)
                                } else {
                                    viewModel.follow(user: user, currentUserId: container.currentUserService.currentUser?.id)
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
                    .padding()
                    .frame(height: 39)
                    .modifier(CornerRadiusModifier())
                    .padding()
                    
                    UserContentListView(user: user)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onAppear {
                
                container.userFollow.updateFollowCounts(for: user.id)
                
            }
        }
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user, isChange: .constant(false))
}
