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
    
    @State var isCreate = false
    @StateObject var viewModel: RepliesViewModel
    @Environment(\.dismiss) var dismiss
    
    init(colloquy: Colloquy, user: User?) {
        self.colloquy = colloquy
        self.user = user
        _viewModel = StateObject(wrappedValue: RepliesViewModel(colloquy.id, currentUser: user))
    }
    
    var body: some View {
        NavigationStack {
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
                .onChange(of: isCreate) {
                    Task {
                        await viewModel.fetchRepliesRefresh(colloquy.id, currentUser: user)
                    }
                }
                
            }
            .padding(.horizontal)
            .navigationTitle("Replies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left.to.line")
                            .fontWeight(.semibold)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                
                CreateReplyView(isCreate: $isCreate, colloquyId: colloquy.id, user: user)
                
            }
        }
    }
}

#Preview {
    RepliesView(colloquy: DeveloperPreview.colloquy, user: DeveloperPreview.user)
}
