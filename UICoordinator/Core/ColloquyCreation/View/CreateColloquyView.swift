//
//  UploadView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct CreateColloquyView: View {
    
    var location: Location?
    var activityId: String?
    
    @StateObject var viewModel: CreateColloquyViewModel
    @EnvironmentObject var container: DIContainer
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    
    @State private var isUploadingError = false
    
    private var user: User? {
        return container.currentUserService.currentUser
    }
    
    init(location: Location? = nil, activityId: String? = nil, viewModelBilder: () -> CreateColloquyViewModel = {
        CreateColloquyViewModel(
            likeCount: ColloquyInteractionCounterService(),
            colloquyService: ColloquyService(
                serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter()),
                repliesFetchingService: FetchRepliesFirebase(
                    fetchLocation: FetchLocationFromFirebase(),
                    userService: UserService())),
            activityUpdate: ActivityServiceUpdate())
    }) {
        
        let vm = viewModelBilder()
        self.location = location
        self.activityId = activityId
        _viewModel = StateObject(wrappedValue: vm)
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                HStack(alignment: .top) {
                    
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(user?.username ?? "no name")
                            .fontWeight(.semibold)
                        
                        TextField("Start a colloquy", text: $caption, axis: .vertical)
                        
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding()
            .navigationTitle("\(location?.name ?? "Reply") Colloquy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button("Post") {
                        
                        Task {
                            
                            await viewModel.uploadColloquy(userId: container.authService.userSession?.uid, caption: caption, locatioId: location?.id, activityId: activityId)
                            
                            if viewModel.errorUpload != nil {
                                self.isUploadingError = true
                            }
                            dismiss()
                        }
                    }
                    .opacity(caption.isEmpty ? 0.3 : 1.0)
                    .disabled(caption.isEmpty)
                    .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.primary)
            .font(.subheadline)
            .alert("Update Error", isPresented: $isUploadingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorUpload ?? "")
            }

        }
    }
}

#Preview {
    CreateColloquyView(location: nil, activityId: nil)
}
