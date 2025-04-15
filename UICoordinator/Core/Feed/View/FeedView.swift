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
                                            await viewModel.fetchColloquies()
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
                            await viewModel.fetchColloquiesRefresh()
                        }
                    }
                }
                .onChange(of: showColloquyCreate) {
                    Task {
                        await viewModel.fetchColloquiesRefresh()
                    }
                }
                .refreshable {
                    Task {
                        await viewModel.fetchColloquiesRefresh()
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
