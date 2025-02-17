//
//  RepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2024.
//

import SwiftUI

struct RepliesView: View {
    
    let colloquy: Colloquy
    @StateObject var viewModel = RepliesViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            ReplyCreateView(colloquy: colloquy)
            
            Divider()
            
            HStack {
                Divider()
                    .frame(width: 10)
                
                LazyVStack {
                    ForEach(viewModel.replies) { colloquy in
                        ColloquyCell(colloquy: colloquy)
                    }
                }
            }
            .padding(.horizontal)
            
            
        }
        .padding(.horizontal)
        .onAppear {
            Task {
                try await viewModel.fitchReplies(cid: colloquy.id)
            }
        }
        .refreshable {
            Task {
                try await viewModel.fitchReplies(cid: colloquy.id)
            }
        }
        .navigationTitle("Replies")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RepliesView(colloquy: DeveloperPreview.colloquy)
}
