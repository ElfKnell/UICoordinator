//
//  UploadView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 20/02/2024.
//

import SwiftUI

struct CreateColloquyView: View {
    @StateObject var viewModel = CreateColloquyViewModel()
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    let location: Location?
    let colloquy: Colloquy?
    
    private var user: User? {
        return UserService.shared.currentUser
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if let colloquy = colloquy {
                    
                    ReplyCreateView(colloquy: colloquy)
                    
                    HStack(alignment: .top) {
                        
                        Text("|")
                            .font(.title)
                            .padding(.horizontal)
                            .opacity(0.5)
                        
                        Spacer()
                    }
                    
                }
                
                HStack(alignment: .top) {
                    
                    CircularProfileImageView(user: user, size: .small)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text(user?.username ?? "no name")
                            .fontWeight(.semibold)
                        
                        TextField("Start a colloquy", text: $caption, axis: .vertical)
                        
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
            .navigationTitle("\(location?.name ?? "New") Colloquy")
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
                            try await viewModel.uploadColloquy(caption: caption, locatioId: location?.id, ownerColloquy: colloquy?.id)
                            
                            dismiss()
                        }
                    }
                    .opacity(caption.isEmpty ? 0.3 : 1.0)
                    .disabled(caption.isEmpty)
                    .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.primary)
            .font(.subheadline)
        }
    }
}

#Preview {
    CreateColloquyView(location: nil, colloquy: nil)
}
