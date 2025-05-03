//
//  RepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/06/2024.
//

import SwiftUI

struct RepliesView: View {
    
    let colloquy: Colloquy
    let user: User?
    @StateObject var viewModel: RepliesViewModel
    
    init(colloquy: Colloquy, user: User?) {
        self.colloquy = colloquy
        self.user = user
        _viewModel = StateObject(wrappedValue: RepliesViewModel(colloquy.id, currentUser: user))
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
                                    await viewModel.fetchReplies(colloquy.id, currentUser: user)
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
                await viewModel.fetchRepliesRefresh(colloquy.id, currentUser: user)
            }
        }
    }
}

#Preview {
    RepliesView(colloquy: DeveloperPreview.colloquy, user: DeveloperPreview.user)
}
