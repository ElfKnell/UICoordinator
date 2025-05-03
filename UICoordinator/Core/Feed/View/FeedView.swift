//
//  FeedView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel = FeedViewModel()
    @State private var showColloquyCreate = false
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.colloquies) { colloquy in
                            ColloquyCell(colloquy: colloquy)
                                .onAppear {
                                    // Load more data when the last post appears
                                    if colloquy == viewModel.colloquies.last {
                                        Task {
                                            await viewModel.fetchColloquies(currentUser: container.currentUserService.currentUser)
                                        }
                                    }
                                }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    
                }
                .onAppear {
                    Task {
                        if viewModel.colloquies.isEmpty {
                            await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                        }
                    }
                }
                .onChange(of: showColloquyCreate) {
                    Task {
                        await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                    }
                }
                .navigationTitle("Colloquies")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        showColloquyCreate.toggle()
                    } label: {
                        Image(systemName: "plus.message")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showColloquyCreate) {
                CreateColloquyView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
