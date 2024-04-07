//
//  UploadView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct CreateColloquyView: View {
    @StateObject var viewModel = CreateThreadViewModel()
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    
    private var user: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                HStack(alignment: .top) {
                    
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(user?.username ?? "no name")
                            .fontWeight(.semibold)
                        
                        TextField("Start a thread", text: $caption, axis: .vertical)
                        
                    }
                    .font(.footnote)
                    
                    Spacer()
                    
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        Task {
                            try await viewModel.uploadThread(caption: caption)
                            dismiss()
                        }
                    }
                    .opacity(caption.isEmpty ? 0.3 : 1.0)
                    .disabled(caption.isEmpty)
                    .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.black)
            .font(.subheadline)
        }
    }
}

#Preview {
    CreateColloquyView()
}
