//
//  FeedView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var viewModel: FeedViewModel
    @State private var showColloquyCreate = false
    @EnvironmentObject var container: DIContainer
    
    init(viewModelBilder: @escaping () -> FeedViewModel = {
        FeedViewModel(
            localUserServise: LocalUserService(),
            fetchColloquies: FetchColloquiesFirebase(
                fetchLocation: FetchLocationFromFirebase()))
    }) {
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.colloquies) { colloquy in
                            ColloquyCellFactory.make(
                                colloquy: colloquy
                            )
                                .onAppear {
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
                .task {
                    if viewModel.colloquies.isEmpty {
                        await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                    }
                    await container.authService.checkUserSession()
                    await container.blockService
                        .fetchBlockers(container
                            .currentUserService.currentUser)
                }
                .onChange(of: viewModel.isSaved) {
                    
                    if viewModel.isSaved {
                        
                        Task {
                            await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                        }
                        
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchColloquiesRefresh(currentUser: container.currentUserService.currentUser)
                    }
                }
                .alert("Fetching error", isPresented: $viewModel.isError) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text(viewModel.messageError ?? "not discription")
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
                .sheet(isPresented: $showColloquyCreate) {
                    CreateColloquyView(isSaved: $viewModel.isSaved)
                        .presentationDetents([.height(340), .medium])
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
