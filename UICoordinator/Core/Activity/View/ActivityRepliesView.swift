//
//  ActivityRepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import SwiftUI

struct ActivityRepliesView: View {
    let activity: Activity
    @State private var showColloquyCreate = false
    @StateObject var viewModel = RepliesViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                ActivityCellMini(activity: activity)
                
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
                    try await viewModel.fitchReplies(cid: activity.id)
                }
            }
            .refreshable {
                Task {
                    try await viewModel.fitchReplies(cid: activity.id)
                }
            }
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showColloquyCreate.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .fontWeight(.bold)
                    }
                }
            }
            .foregroundStyle(.primary)
            .font(.subheadline)
            .sheet(isPresented: $showColloquyCreate, content: {
                CreateColloquyView(activityId: activity.id)
            })
        }
    }
}

#Preview {
    ActivityRepliesView(activity: DeveloperPreview.activity)
}
