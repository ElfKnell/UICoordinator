//
//  RepliesView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/06/2024.
//

import SwiftUI

struct ReplyCreateView: View {
    
    let colloquy: Colloquy
    let isNeedButton: Bool
    @Binding var isEdit: Bool
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .top, spacing: 12) {
                
                CircularProfileImageView(user: colloquy.user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        
                        Text(colloquy.user?.username ?? "")
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text(colloquy.timestamp.timestampString())
                            .font(.callout)
                            .foregroundStyle(Color.accentColor)
                        
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
                            .font(.callout)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            
            HStack {
                VerticalSeparatorView()
                
                if isNeedButton {
                    Button {
                        isEdit.toggle()
                    } label: {
                        Image(systemName: isEdit ? "pencil.slash" : "pencil.line")
                    }
                }
            }
            
        }
    }
}

#Preview {
    ReplyCreateView(colloquy: DeveloperPreview.colloquy, isNeedButton: false, isEdit: .constant(false))
}
