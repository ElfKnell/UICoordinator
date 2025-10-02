//
//  CreateReplyView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import SwiftUI

struct CreateReplyView: View {
    
    @Binding var isCreate: Bool
    let colloquyId: String?
    let activityId: String?
    let user: User?
    @StateObject var viewModel: CreateReplyViewModel
    @FocusState private var isSelected: Bool
    
    init(isCreate: Binding<Bool>,
         colloquyId: String?,
         activityId: String?,
         user: User?,
         viewModelBilder: () -> CreateReplyViewModel = {
        CreateReplyViewModel(
            colloquyService: ColloquyService(
                serviceDetete: FirestoreGeneralDeleteService(
                    db: FirestoreAdapter()),
                repliesFetchingService: FetchRepliesFirebase(
                    fetchLocation: FetchLocationFromFirebase(),
                    userService: UserService()),
                deleteLikes: LikesDeleteService()),
            increment: ColloquyInteractionCounterService(),
            contentModerator: ContentModerator(),
            activityUpdate: ActivityServiceUpdate())
    }) {
        
        let vm = viewModelBilder()
        self._isCreate = isCreate
        self._viewModel = StateObject(wrappedValue: vm)
        self.colloquyId = colloquyId
        self.activityId = activityId
        self.user = user
        self.isSelected = true
    }
    
    var body: some View {
        
        if !viewModel.isLoading {
            
            HStack {
                
                CircularProfileImageView(user: user, size: .small)
                
                TextField("Write your reply.", text: $viewModel.text,  axis: .vertical)
                    .lineLimit(0...10)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .modifier(CornerRadiusModifier())
                    .focused($isSelected)
                    .padding()
                    .overlay(alignment: .leading) {
                        
                        if isSelected {
                            
                            Button {
                                viewModel.text = ""
                                isSelected = false
                                
                            } label: {
                                
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                    .font(.title2)
                                
                            }
                        }
                    }
                    .overlay(alignment: .trailing) {
                        
                        if isSelected {
                            
                            Button {
                                
                                Task {
                                    await viewModel.saveColloquy(
                                        colloquyId: colloquyId,
                                        activityId: activityId,
                                        userId: user?.id
                                    )
                                    isCreate.toggle()
                                }
                                
                                isSelected = false
                                
                            } label: {
                                
                                Image(systemName: "checkmark.message.fill")
                                    .foregroundStyle(.green)
                                    .font(.title)
                                
                            }
                        }
                    }
            }
            .padding(.horizontal)
            .alert("Create error", isPresented: $viewModel.isError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.messageError ?? "not discription")
            }
            .onAppear {
                isSelected = true
            }
        } else {
            LoadingView(size: 100)
        }
    }
}

#Preview {
    CreateReplyView(isCreate: .constant(false),
                    colloquyId: nil,
                    activityId: nil,
                    user: nil)
}
