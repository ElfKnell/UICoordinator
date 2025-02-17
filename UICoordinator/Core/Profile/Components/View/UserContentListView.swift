//
//  UserContentListView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 25/02/2024.
//

import SwiftUI

struct UserContentListView: View {
    @StateObject var viewModel: UserContentListViewModel

    @State private var selectedFilter: ProfileColloquyFilter = .colloquies
    @Namespace var animation
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
    }
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileColloquyFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ProfileColloquyFilter.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundStyle(.black)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            
            if selectedFilter == .colloquies {
                LazyVStack {
                    ForEach(viewModel.colloquies) { colloquy in
                        ColloquyCell(colloquy: colloquy)
                    }
                }
                .onAppear {
                    Task  {
                        try await viewModel.fetchUserColloquies()
                    }
                }
            } else {
                LazyVStack {
                    ForEach(viewModel.replies) { colloquy in
                        RepliesView(colloquy: colloquy)
                    }
                }
                .onAppear {
                    Task {
                        try await viewModel.fetchUserReplies()
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    UserContentListView(user: DeveloperPreview.user)
}
