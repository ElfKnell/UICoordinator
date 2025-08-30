//
//  ActivityContentListView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 11/07/2024.
//

import SwiftUI

struct ActivityContentListView: View {
    
    let currentUser: User?
    
    @Binding var isCreate: Bool
    
    @State private var selectedFilter: ActivityOwner = .allUsersActivities
    @State var isDelete = false
    @State var isUpdate = false
    
    @StateObject var viewModel: ActivityViewModel
    @StateObject var activityAll: FetchAllActivityViewModel
    @StateObject var activityMy: FetchMyActivity
    
    @Namespace var animation
    
    init(currentUser: User?, isCreate: Binding<Bool>) {
        self.currentUser = currentUser
        
        self._viewModel = .init(wrappedValue: ActivityViewModelFactory.makeActivityViewModel(for: currentUser))
        
        self._activityAll = .init(wrappedValue: ActivityViewModelFactory.makeFetchAllActivityViewModel())
        
        self._activityMy = .init(wrappedValue: ActivityViewModelFactory.makeFetchMyActivityViewModel(for: currentUser))
        
        self._isCreate = isCreate
    }
    
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
                        
                        ForEach(activityAll.activities) { activity in
                            ActivityCellFactory.make(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                                .task {
                                    
                                    if activity == activityAll.activities.last {
                                        
                                        await activityAll
                                            .fetchFollowersActivity(
                                                currentUser: currentUser)
                                        
                                    }
                                }
                        }
                    }
                    .task {
                        await activityAll.refresh(currentUser: currentUser)
                    }
                    .alert("Fetching error", isPresented: $activityAll.isError) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text(activityAll.errorMessage ?? "not discription")
                    }
                    
                } else if selectedFilter == .currentUserActivities {

                    LazyVStack {
                        
                        if !activityMy.activities.isEmpty {
                            
                            ForEach(activityMy.activities) { activity in
                                ActivityCellFactory.make(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                                    .task {
                                        if activity == activityMy.activities.last {
                                            
                                            await activityMy
                                                .fetchMyActivity(
                                                    currentUser: currentUser)
                                            
                                        }
                                    }
                            }
                        } else {
                            ContentUnavailableView("No Activity", systemImage: "globe.desk", description: Text("You have not set up any activity yet. Tap on the \(Image(systemName: "pencil.tip.crop.circle.badge.plus")) button in the toolbar to begin."))
                        }
                    }
                    .task {
                        Task {
                            await activityMy.refresh(currentUser: currentUser)
                        }
                    }
                    .onChange(of: isUpdate) {
                        Task {
                            await activityMy.refresh(currentUser: currentUser)
                        }
                    }
                    .onChange(of: isCreate) {
                        Task {
                            await activityMy.refresh(currentUser: currentUser)
                        }
                    }
                    .alert("Fetching error", isPresented: $activityMy.isError) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text(activityMy.errorMessage ?? "not discription")
                    }
                    
                } else {
                    
                    LazyVStack {
                        if !viewModel.activities.isEmpty {
                            ForEach(viewModel.activities) { activity in
                                ActivityCellFactory.make(activity: activity, isDelete: $isDelete, isUpdate: $isUpdate)
                            }
                        } else {
                            ContentUnavailableView("No Like Activity", systemImage: "globe.desk", description: Text("You have not liked any activity yet."))
                        }
                    }
                    .task {
                        await viewModel.fetchLikeActivity(currentUser: currentUser)
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
    ActivityContentListView(currentUser: nil, isCreate: .constant(false))
}
