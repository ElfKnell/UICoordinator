//
//  CreateReplyView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import SwiftUI

struct CreateReplyView: View {
    
    @Binding var isCreate: Bool
    @State var viewModel = CreateReplyViewModel()
    @FocusState private var isSearch: Bool
    
    let colloquyId: String
    let user: User?
    
    var body: some View {
        HStack {
            
            CircularProfileImageView(user: user, size: .small)
            
            TextField("Write your reply.", text: $viewModel.text,  axis: .vertical)
                .lineLimit(0...10)
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
                .modifier(CornerRadiusModifier())
                .focused($isSearch)
                .padding()
                .overlay(alignment: .leading) {
                    
                    if isSearch {
                        
                        Button {
                            viewModel.text = ""
                            isSearch = false
                            
                        } label: {
                            
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                                .font(.title2)
                            
                        }
                    }
                }
                .overlay(alignment: .trailing) {
                    
                    if isSearch {
                        
                        Button {
                            
                            Task {
                                await viewModel.saveColloquy(colloquyId, userId: user?.id)
                            }
                            isCreate.toggle()
                            isSearch = false
                            
                        } label: {
                            
                            Image(systemName: "checkmark.message.fill")
                                .foregroundStyle(.green)
                                .font(.title)
                            
                        }
                    }
                }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CreateReplyView(isCreate: .constant(false), colloquyId: "", user: nil)
}
