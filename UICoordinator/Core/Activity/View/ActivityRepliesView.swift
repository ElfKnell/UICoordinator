//
//  ActivityRepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/03/2025.
//

import SwiftUI

struct ActivityRepliesView: View {
    
    let activity: Activity
    let user: User?
    
    @State private var showColloquyCreate = false
    @State var isChange = false
    
    @StateObject var viewModel: RepliesViewModel
    @Environment(\.dismiss) var dismiss
    
    init(activity: Activity, user: User?) {
        self.activity = activity
        self.user = user
        _viewModel = StateObject(wrappedValue: RepliesViewModelFactory.makeRepliesViewModel(activity.id, currentUser: user, isOrdering: true))
    }
    
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
                            ColloquyCellFactory.make(colloquy: reply)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchReplies(activity.id, currentUser: user)
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
                    await viewModel.fetchRepliesRefresh(activity.id, currentUser: user)
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
                    .presentationDetents([.height(340), .medium])
            })
        }
    }
}

#Preview {
    ActivityRepliesView(activity: DeveloperPreview.activity, user: DeveloperPreview.user)
}
