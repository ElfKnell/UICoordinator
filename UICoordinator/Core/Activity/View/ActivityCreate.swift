//
//  ActivityCreate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2025.
//

import SwiftUI

struct ActivityCreate: View {
    
    var nameActivyty: String
    
    @StateObject var viewModel: ActivityCreateViewModel
    @EnvironmentObject var container: DIContainer
    
    init(nameActivyty: String, viewModelBilder: () -> ActivityCreateViewModel = { ActivityCreateViewModel(
        createActivity: ActivityCreateService(),
        fetchingActivity: FetchingActivityService())
    }) {
        self.nameActivyty = nameActivyty
        let mv = viewModelBilder()
        self._viewModel = StateObject(wrappedValue: mv)
        
    }
    
    var body: some View {
        Group {
            if viewModel.activity != nil {
                ActivityMapEditView(activity: viewModel.activity!)
            } else {
                LoadingView(size: 150)
            }
        }
        .task {
            viewModel.activity = await viewModel.createActivity(name: nameActivyty, currentUserId: container.currentUserService.currentUser?.id)
        }
        .alert("Fetching error", isPresented: $viewModel.isError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "not discription")
        }
    }
}

#Preview {
    ActivityCreate(nameActivyty: "")
}
