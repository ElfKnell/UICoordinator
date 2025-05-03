//
//  ActivityCreate.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2025.
//

import SwiftUI

struct ActivityCreate: View {
    var nameActivyty: String
    
    @State private var activity: Activity?
    @StateObject var viewModel = ActivityViewModel()
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        Group {
            if activity != nil {
                ActivityEditView(activity: activity!)
            } else {
                LoadingView(width: 150, height: 150)
            }
        }
        .onAppear {
            Task {
                activity = try await viewModel.createActivity(name: nameActivyty, currentUserId: container.currentUserService.currentUser?.id)
            }
        }
    }
}

#Preview {
    ActivityCreate(nameActivyty: "")
}
