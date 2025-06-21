//
//  ReplyComposerView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 10/05/2025.
//

import SwiftUI

struct ReplyComposerView: View {
    
    let colloquy: Colloquy
    let user: User?
    let isEditButton: Bool
    
    @State var isCreate = false
    @State var isVisible = false
    
    @StateObject var viewModel: RepliesViewModel
    
    init(colloquy: Colloquy, user: User?, isEditButton: Bool) {
        self.colloquy = colloquy
        self.user = user
        _viewModel = StateObject(wrappedValue: RepliesViewModelFactory.makeRepliesViewModel(colloquy.id, currentUser: user, isOrdering: false))
        self.isEditButton = isEditButton
        _isVisible = .init(wrappedValue: !isEditButton)
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            ReplyCreateView(colloquy: colloquy, isNeedButton: isEditButton, isEdit: $isVisible)
            
            Divider()
            
            HStack {
                Divider()
                    .frame(width: 10)
                
                LazyVStack {
                    ForEach(viewModel.replies) { reply in
                        ColloquyCellFactory.make(colloquy: reply)
                            .onAppear {
                                Task {
                                    await viewModel.fetchReplies(colloquy.id, currentUser: user)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal)
            .onChange(of: isCreate) {
                Task {
                    await viewModel.fetchRepliesRefresh(colloquy.id, currentUser: user)
                }
            }
        }
        .padding(.top)
        .safeAreaInset(edge: .bottom) {
            
            if isVisible {
                CreateReplyView(isCreate: $isCreate, colloquyId: colloquy.id, user: user)
            }
        }
        
    }
}

#Preview {
    ReplyComposerView(colloquy: DeveloperPreview.colloquy, user: DeveloperPreview.user, isEditButton: true)
}
