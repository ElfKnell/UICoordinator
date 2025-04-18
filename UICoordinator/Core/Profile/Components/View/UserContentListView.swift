//
//  UserContentListView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct UserContentListView: View {
    @StateObject var viewModel: UserContentListViewModel

    @State private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    @State private var selectedFilter: ProfileColloquyFilter = .colloquies
    @Namespace var animation
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
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
                        
                        ColloquyCell(colloquy: colloquy)
                            .padding(.horizontal, isLandscape ? 41 : 1)
                            .onAppear {
                                
                                if colloquy == viewModel.colloquies.last {
                                    
                                    Task {
                                        try await viewModel.fetchColloquiesNext()
                                        
                                    }
                                }
                                
                            }
                            
                    }
                    
                    if viewModel.isLoading {
                        
                        ProgressView()
                            .padding()
                    }
                }
                .onAppear {
                    Task  {
                        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                            isLandscape = UIDevice.current.orientation.isLandscape
                        }
                        
                    }
                }
            } else {
                LazyVStack {
                    if !viewModel.replies.isEmpty || viewModel.isLoading {
                        ForEach(viewModel.replies) { colloquy in
                            RepliesView(colloquy: colloquy)
                                .padding(.horizontal, isLandscape ? 41 : 1)
                                .onAppear {
                                    
                                    if colloquy == viewModel.colloquies.last {
                                        
                                        Task {
                                            await viewModel.fetchNextReplies()
                                        }
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
                .onAppear {
                    Task {
                        
                        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
                        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                            isLandscape = UIDevice.current.orientation.isLandscape
                        }
                        
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            Task {
                await viewModel.loadDate()
            }
        }
    }
}

#Preview {
    UserContentListView(user: DeveloperPreview.user)
}
