//
//  ConfirmationLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import SwiftUI
import MapKit

struct ConfirmationLocationView: View {
    let coordinate: CLLocationCoordinate2D
    var activityId: String?
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ConfirmationLocationViewModel()
    @Binding var isSave: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    FormInfoLocation(name: $viewModel.name, description: $viewModel.description, address: $viewModel.address)
                    
                    Divider()
                    
                    CoordinateInfoView(coordinate: coordinate)
                    
                }
                .padding()
                .background(.white)
                .modifier(CornerRadiusModifier())
                .padding()
            }
            .navigationTitle("Create Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
            
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            try await viewModel.uploadLocationWithCoordinate(coordinate: coordinate, activityId: activityId)
                            isSave.toggle()
                            
                            dismiss()
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                    .opacity(viewModel.name.isEmpty ? 0.3 : 1.0)
                    .disabled(viewModel.name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ConfirmationLocationView(coordinate: .startLocation, isSave: .constant(false))
}
