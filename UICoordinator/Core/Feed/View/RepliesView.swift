//
//  RepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2024.
//

import SwiftUI

struct RepliesView: View {
    
    let colloquy: Colloquy
    @StateObject var viewModel: RepliesViewModel
    
    init(colloquy: Colloquy) {
        self.colloquy = colloquy
        _viewModel = StateObject(wrappedValue: RepliesViewModel(colloquy.id))
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            ReplyCreateView(colloquy: colloquy)
            
            Divider()
            
            HStack {
                Divider()
                    .frame(width: 10)
                
                LazyVStack {
                    ForEach(viewModel.replies) { reply in
                        ColloquyCell(colloquy: reply)
                            .onAppear {
                                Task {
                                    await viewModel.fetchReplies(colloquy.id)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal)
            
            
        }
        .padding(.horizontal)
        .refreshable {
            Task {
                await viewModel.fetchRepliesRefresh(colloquy.id)
            }
        }
    }
}

#Preview {
    RepliesView(colloquy: DeveloperPreview.colloquy)
}
