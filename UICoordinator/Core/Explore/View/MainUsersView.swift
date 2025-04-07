//
//  MainUsersView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2025.
//

import SwiftUI

struct MainUsersView: View {
    
    @StateObject var viewModel = MainUsersViewModel()
    
    var body: some View {
        ExploreView(users: viewModel.users)
    }
}

#Preview {
    MainUsersView()
}
