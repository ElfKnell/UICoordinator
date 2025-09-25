//
//  UploadView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct CreateColloquyView: View {
    
    @Binding var isSaved: Bool
    
    var location: Location?
    var activityId: String?
    
    @StateObject var viewModel: CreateColloquyViewModel
    @EnvironmentObject var container: DIContainer
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var isUploadingError = false
    @FocusState private var isSearch: Bool
    
    private var user: User? {
        return container.currentUserService.currentUser
    }
    
    init(isSaved: Binding<Bool>,
         location: Location? = nil,
         activityId: String? = nil,
         viewModelBilder: () -> CreateColloquyViewModel = {
        CreateColloquyViewModel(
            likeCount: ColloquyInteractionCounterService(),
            colloquyService: ColloquyService(
                serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter()),
                repliesFetchingService: FetchRepliesFirebase(
                    fetchLocation: FetchLocationFromFirebase(),
                    userService: UserService()),
                deleteLikes: LikesDeleteService()),
            contentModerator: ContentModerator())
    }) {
        
        let vm = viewModelBilder()
        self.location = location
        self.activityId = activityId
        self._isSaved = isSaved
        _viewModel = StateObject(wrappedValue: vm)
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if !viewModel.isLoading {
                    
                    HStack(alignment: .top) {
                        
                        CircularProfileImageView(user: user, size: .small)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(user?.username ?? "no name")
                                .fontWeight(.semibold)
                            
                            TextField("Start a colloquy",
                                      text: $caption,
                                      axis: .vertical)
                            .focused($isSearch)
                            .accessibilityLabel("Colloquy input field")
                            .accessibilityHint("Enter the text of your colloquy")
                            
                        }
                        .font(.headline)
                        
                        Spacer()
                        
                        if !caption.isEmpty {
                            
                            Button {
                                caption = ""
                                isSearch = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                    .foregroundStyle(.gray)
                            }
                            .accessibilityLabel("Clear text")
                            .accessibilityHint("Clears the text you have typed")
                            
                        }
                    }
                    
                    Spacer()
                    
                } else {
                    
                    LoadingView(size: 200)
                    
                }
            }
            .padding()
            .navigationTitle("\(location?.name ?? self.activityId != nil ? "Reply" : "") Colloquy")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isSearch = true
            }
            .alert("Create error", isPresented: $viewModel.isError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "not discription")
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .accessibilityLabel("Cancel button")
                    .accessibilityHint("Dismisses the colloquy creation screen")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button("Post") {
                        
                        Task {
                            
                            await viewModel.uploadColloquy(userId: container.authService.userSession?.uid, caption: caption, locatioId: location?.id)
                            
                            isSaved = true
                            
                            if !viewModel.isError {
                                dismiss()
                            }
                            
                        }
                    }
                    .opacity(caption.isEmpty ? 0.3 : 1.0)
                    .disabled(caption.isEmpty)
                    .fontWeight(.semibold)
                    .accessibilityLabel("Post button")
                    .accessibilityHint(caption.isEmpty ? "Disabled, enter text to enable" : "Posts the colloquy")
                }
            }
            .foregroundStyle(.primary)
            .font(.headline)

        }
    }
}

#Preview {
    CreateColloquyView(isSaved: .constant(false),
                       location: nil,
                       activityId: nil)
}
