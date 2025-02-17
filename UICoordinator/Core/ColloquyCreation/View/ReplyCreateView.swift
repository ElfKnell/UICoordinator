//
//  RepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2024.
//

import SwiftUI

struct ReplyCreateView: View {
    
    let colloquy: Colloquy
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            CircularProfileImageView(user: colloquy.user, size: .small)
            
            VStack(alignment: .leading, spacing: 4) {
                
                HStack {
                    
                    Text(colloquy.user?.username ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(colloquy.timestamp.timestampString())
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray3))
                    
                }
                
                HStack {
                    
                    if let name = colloquy.location?.name {
                        NavigationLink {
                            LocationColloquyView(location: colloquy.location ?? DeveloperPreview.location)
                        } label: {
                            Text(name)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    Text(colloquy.caption)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

#Preview {
    ReplyCreateView(colloquy: DeveloperPreview.colloquy)
}
