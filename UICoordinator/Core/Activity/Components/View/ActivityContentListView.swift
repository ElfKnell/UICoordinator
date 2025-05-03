//
//  ActivityContentListView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/07/2024.
//

import SwiftUI

struct ActivityContentListView: View {
    
    @StateObject var viewModel = ActivityViewModel()
    @EnvironmentObject var container: DIContainer
    @State private var selectedFilter: ActivityOwner = .allUsersActivities
    @Namespace var animation
    @State var isDelete = false
    @State var isUpdate = false
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ActivityOwner.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ActivityOwner.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            if !isDelete {
                
                if selectedFilter == .allUsersActivities {
                    
                    LazyVStack {
                        ForEach(viewModel.activities) { activity in
                            ActivityCell(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                        }
                    }
                    .onAppear {
                        Task {
                            try await viewModel.fetchActivity(typeActivity: .followerActivity, currentUser: container.currentUserService.currentUser)
                        }
                    }
                    
                } else if selectedFilter == .currentUserActivities {

                    LazyVStack {
                        if !viewModel.activities.isEmpty {
                            ForEach(viewModel.activities) { activity in
                                ActivityCell(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                            }
                        } else {
                            ContentUnavailableView("No Activity", systemImage: "globe.desk", description: Text("You have not set up any activity yet. Tap on the \(Image(systemName: "pencil.tip.crop.circle.badge.plus")) button in the toolbar to begin."))
                        }
                    }
                    .onAppear {
                        Task {
                            try await viewModel.fetchActivity(typeActivity: .myActivity, currentUser: container.currentUserService.currentUser)
                        }
                    }
                    .onChange(of: isUpdate) {
                        Task {
                            try await viewModel.fetchActivity(typeActivity: .myActivity, currentUser: container.currentUserService.currentUser)
                        }
                    }
                    
                } else {
                    
                    LazyVStack {
                        if !viewModel.activities.isEmpty {
                            ForEach(viewModel.activities) { activity in
                                ActivityCell(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                            }
                        } else {
                            ContentUnavailableView("No Like Activity", systemImage: "globe.desk", description: Text("You have not liked any activity yet."))
                        }
                    }
                    .onAppear {
                        Task {
                            try await viewModel.fetchActivity(typeActivity: .likeActivity, currentUser: container.currentUserService.currentUser)
                        }
                    }
                    .onChange(of: isUpdate) {
                        Task {
                            try await viewModel.fetchActivity(typeActivity: .likeActivity, currentUser: container.currentUserService.currentUser)
                        }
                    }
                }
                
            } else {
                
                LoadingView(width: 150, height: 150)
                
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ActivityContentListView()
}
