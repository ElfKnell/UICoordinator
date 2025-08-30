//
//  UserContentListView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct UserContentListView: View {
    @StateObject var viewModel: UserContentListViewModel
    @EnvironmentObject var container: DIContainer
    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @State private var selectedFilter: ProfileColloquyFilter = .colloquies
    @State var isDeleted = false
    @Namespace var animation
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserContentListViewModelFactory.make(user: user))
    }
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileColloquyFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ProfileColloquyFilter.allCases) { filter in
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
            
            if selectedFilter == .colloquies {
                
                LazyVStack {
                    
                    ForEach(viewModel.colloquies) { colloquy in
                        
                        if viewModel.user == container.currentUserService.currentUser {
                            
                            ColloquyCellForCurrentUserFactory.make(colloquy: colloquy,
                                                       user: viewModel.user,
                                                       isDeleted: $isDeleted)
                                .padding(.horizontal, isLandscape ? 41 : 1)
                                .task {
                                    
                                    if colloquy == viewModel.colloquies.last {
                                        
                                        await viewModel.fetchColloquiesNext()
                                    }
                                    
                                }
                            
                        } else {
                            
                            ColloquyCellFactory.make(colloquy: colloquy)
                                .padding(.horizontal, isLandscape ? 41 : 1)
                                .task {
                                    
                                    if colloquy == viewModel.colloquies.last {
                                        
                                        await viewModel.fetchColloquiesNext()
                                    }
                                    
                                }
                        }
                            
                            
                    }
                    
                    if viewModel.isLoading {
                        
                        ProgressView()
                            .padding()
                    }
                }
                .task {
                    
                    await viewModel.startLoadColloquies()
                    
                    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                        isLandscape = UIDevice.current.orientation.isLandscape
                    }
                }
                .onChange(of: isDeleted) {
                    Task {
                        await viewModel.startLoadColloquies()
                    }
                }
            } else {
                LazyVStack {
                    if !viewModel.replies.isEmpty || viewModel.isLoading {
                        ForEach(viewModel.replies) { colloquy in
                            ReplyComposerView(colloquy: colloquy, user: container.currentUserService.currentUser, isEditButton: true)
                                .padding(.horizontal, isLandscape ? 41 : 1)
                                .task {
                                    
                                    if colloquy == viewModel.colloquies.last {
                                        
                                        await viewModel.fetchNextReplies(currentUser: container.currentUserService.currentUser)
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            
                            ProgressView()
                                .padding()
                        }
                    } else {
                        
                        Text("  \(viewModel.user.fullname), has not yet responded, and we are still waiting for their reply.")
                            .font(.title)
                            .padding()
                    }
                }
                .padding(.horizontal)
                .task {
                    
                    await viewModel.startReplies(currentUser: container.currentUserService.currentUser)
                    
                    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                    NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                        isLandscape = UIDevice.current.orientation.isLandscape
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .alert("Fetching error", isPresented: $viewModel.isError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(viewModel.messageError ?? "not discription")
        }
        
    }
}

#Preview {
    UserContentListView(user: DeveloperPreview.user)
}
