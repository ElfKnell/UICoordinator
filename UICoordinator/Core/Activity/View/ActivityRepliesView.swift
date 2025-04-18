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
    @State var isChange = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                ActivityCellMini(activity: activity)
                
                Divider()
                
                HStack {
                    Divider()
                        .frame(width: 10)
                    
                    LazyVStack {
                        ForEach(viewModel.replies) { reply in
                            ColloquyCell(colloquy: reply)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchReplies(activity.id)
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)
                
                
            }
            .padding(.horizontal)
            .onAppear {
                Task {
                    await viewModel.fetchRepliesRefresh(activity.id)
                }
            }
            .refreshable {
                Task {
                    await viewModel.fetchRepliesRefresh(activity.id)
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
