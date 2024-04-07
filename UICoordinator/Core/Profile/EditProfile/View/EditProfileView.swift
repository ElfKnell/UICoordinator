//
//  EditeProfileView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 24/02/2024.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    //.ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
