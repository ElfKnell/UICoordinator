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
    @StateObject var viewModel = ProfileViewModel()
    @EnvironmentObject var userFollow: UserFollowers
    @Environment(\.modelContext) private var modelContext
    @Binding var isChange: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing: 20) {
                    
                    ProfileHeaderView(user: user)
                    
                    HStack {
                        
                        Spacer()
                        
                        if user.id != CurrentUserService.sharedCurrent.currentUser?.id {
                            
                            Button {
                                
                                if userFollow.isFollowingCurrentUser(uid: user.id) {
                                    viewModel.unfollow(user: user,
                                                       followers: userFollow.getFollowersCurrentUser())
                                } else {
                                    viewModel.follow(user: user)
                                }
                                isChange.toggle()
                                dismiss()

                            } label: {
                                
                                Text(userFollow.isFollowingCurrentUser(uid: user.id) ? "Unfollow" : "Follow")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 32)
                                    .background(.black)
                                    .cornerRadius(11)
                            }
                        }
                        
                        Spacer()
                        
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
                
                userFollow.fetchFollowCount(userId: user.id)
                
            }
        }
    }
}

#Preview {
    ProfileView(user: DeveloperPreview.user, isChange: .constant(false))
}
