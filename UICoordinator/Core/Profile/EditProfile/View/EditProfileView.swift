//
//  EditeProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    let user: User
    @State private var nickname = ""
    @State private var bio = ""
    @State private var link = ""
    @State private var isPrivateProfile = false
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditProfileViewModel()
    @Binding var isSaved: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                            
                            Text(user.fullname)
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .any(of: [.images, .not(.videos)])) {
                            
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: user, size: .small)
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Nickname")
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("@")
                            TextField("nickname...", text: $nickname)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Bio")
                            .fontWeight(.semibold)
                        
                        TextField("Enter your bio...", text: $bio, axis: .vertical)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Link")
                        
                        HStack {
                            TextField("Add link...", text: $link)
                        }
                    }
                    
                    Divider()
                    
                    Toggle("Private profile", isOn: $isPrivateProfile)
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .modifier(CornerRadiusModifier())
                .padding()
                .foregroundStyle(.black)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                nickname = user.username
                
                if let bio = user.bio {
                    self.bio = bio
                }
                if let link = user.link {
                    self.link = link
                }
            }
            .alert("Delete User Account", isPresented: $viewModel.isDelete) {
                Button("Cancel", role: .cancel) {}
                
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteCurrentUser(userId: user.id)
                        container.authService.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account?")
                    .foregroundStyle(.red)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    HStack {
                        Button("Save") {
                            Task {
                                await viewModel.updateUserData(user: user,
                                                               nickname: nickname,
                                                               bio: bio,
                                                               link: link,
                                                               isPrivateProfile: isPrivateProfile)
                                
                                isSaved.toggle()
                                dismiss()
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        
                        Button {
                            viewModel.isDelete.toggle()
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(user: DeveloperPreview.user, isSaved: .constant(false))
}
