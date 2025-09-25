//
//  EditeProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct EditProfileView: View {
    
    let user: User
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) var dismiss
    @Binding var isSaved: Bool
    @StateObject var viewModel: EditProfileViewModel
    
    init(user: User, isSaved: Binding<Bool>) {
        self.user = user
        self._isSaved = isSaved
        self._viewModel = StateObject(
            wrappedValue: EditProfileViewModelBuilder.make()
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                if !viewModel.isLoading {
                    
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
                                TextField("nickname...", text: $viewModel.nickname)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Bio")
                                .fontWeight(.semibold)
                            
                            TextField("Enter your bio...", text: $viewModel.bio, axis: .vertical)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Link")
                            
                            HStack {
                                TextField("Add link...", text: $viewModel.link)
                            }
                        }
                        
                        Divider()
                        
                        Toggle("Private profile", isOn: $viewModel.isPrivateProfile)
                        
                        Divider()
                        
                        HStack {
                            
                            Link(destination: URL(string: viewModel.privacyPolicy)!) {
                                Text("Privacy Policy")
                            }
                            .foregroundStyle(.blue)
                            
                            Text("&")
                            
                            Link(destination: URL(string: viewModel.eula)!) {
                                Text("EULA")
                            }
                            .foregroundStyle(.blue)
                            .padding(.vertical)
                        }
                        
                        Divider()
                        
                        Button {
                            viewModel.isDelete.toggle()
                        } label: {
                            Label("Delete account",
                                  systemImage: "trash.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .foregroundStyle(.white)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .font(.subheadline)
                    .padding()
                    .background(.white)
                    .modifier(CornerRadiusModifier())
                    .padding()
                    .foregroundStyle(.black)
                    
                } else {
                    LoadingView(size: 300)
                }
                
            }
            .alert("Delete error", isPresented: $viewModel.isError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "not discription")
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                viewModel.nickname = user.username
                
                if let bio = user.bio {
                    viewModel.bio = bio
                }
                if let link = user.link {
                    viewModel.link = link
                }
            }
            .alert("Delete User Account", isPresented: $viewModel.isDelete) {
                Button("Cancel", role: .cancel) {}
                
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteCurrentUser(
                            user: container.currentUserService.currentUser,
                            userSession: container.authService.userSession)
                        
                        if !viewModel.isError {
                            container.authService.signOut()
                        }
                    }
                }
            } message: {
                
                Text("Deleting your account is permanent. All your data will be lost and cannot be recovered. Are you sure you want to continue?")

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundStyle(.primary)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    HStack {
                        Button("Save") {
                            Task {
                                await viewModel
                                    .updateUserData(
                                        user: user,
                                        nickname: viewModel.nickname,
                                        bio: viewModel.bio,
                                        link: viewModel.link,
                                        isPrivateProfile: viewModel.isPrivateProfile
                                    )
                                
                                isSaved.toggle()
                                if !viewModel.isError {
                                    dismiss()
                                }
                            }
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(user: DeveloperPreview.user, isSaved: .constant(false))
}
