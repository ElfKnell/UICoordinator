//
//  MainUsersView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2025.
//

import SwiftUI

struct MainUsersView: View {
    
    @StateObject var viewModel: MainUsersViewModel
    @EnvironmentObject var container: DIContainer
    
    init(viewModelBilder: () -> MainUsersViewModel = {
        MainUsersViewModel(
            fetchUsers: FetchingUsersServiceFirebase(
                repository: FirestoreUserRepository()))
    }) {
        let vm = viewModelBilder()
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ExploreView(users: viewModel.users)
            .onAppear {
                Task {
                    await viewModel.featchUsers(userId: container.authService.userSession?.uid)
                }
            }
    }
}

#Preview {
    MainUsersView()
}
