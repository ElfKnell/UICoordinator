//
//  LikeButtonView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 09/05/2025.
//

import SwiftUI

struct LikeButtonView<T: LikeObject>: View {
    
    let colloquyOrActivity: T
    let userId: String?
    @EnvironmentObject var viewModel: LikesViewModel
    
    var body: some View {
        
        Group {
            
            Button {
                Task {
                    await viewModel.doLike(userId: colloquyOrActivity.ownerUid, currentUserId: userId, likeToObject: colloquyOrActivity)
                }
            } label: {
                if viewModel.likeId == nil {
                    Image(systemName: "heart")
                } else {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }
            }
            
        }
    }
}

#Preview {
    LikeButtonView(colloquyOrActivity: DeveloperPreview.colloquy, userId: nil)
}
