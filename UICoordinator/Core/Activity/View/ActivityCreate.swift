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
    
    var body: some View {
        Group {
            if activity != nil {
                ActivityRoutesEditView(activity: activity!)
            } else {
                LoadingView(width: 150, height: 150)
            }
        }
        .onAppear {
            Task {
                activity = try await viewModel.createActivity(name: nameActivyty)
            }
        }
    }
}

#Preview {
    ActivityCreate(nameActivyty: "")
}
