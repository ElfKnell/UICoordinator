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
            
            ReplyComposerView(colloquy: colloquy, user: user, isEditButton: false)
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
        }
    }
}

#Preview {
    RepliesView(colloquy: DeveloperPreview.colloquy, user: DeveloperPreview.user)
}
