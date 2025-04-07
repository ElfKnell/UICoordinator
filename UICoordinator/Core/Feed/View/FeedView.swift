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
                        Task {
                            try await viewModel.fetchColloquies()
                        }
                    }
                }
                .refreshable {
                    Task {
                        try await viewModel.fetchColloquies()
                    }
                }
                .navigationTitle("Colloquies")
                .navigationBarTitleDisplayMode(.inline)
                
                VStack() {
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            showColloquyCreate.toggle()
                        } label: {
                            Image(systemName: "plus.message")
                        }
                        .font(.largeTitle)
                        .padding()
                        
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
