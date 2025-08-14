//
//  ConfirmationLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import SwiftUI
import MapKit

struct ConfirmationLocationView: View {
    
    var activityId: String?
    let coordinate: CLLocationCoordinate2D?
    
    @Binding var isSave: Bool
    @Binding var annotation: MKPointAnnotation?
    
    @StateObject var viewModel = ConfirmationLocationViewModel()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    FormInfoLocation(
                        name: $viewModel.name,
                        description: $viewModel.description,
                        address: $viewModel.address)
                    
                    Divider()
                    
                    CoordinateInfoView(coordinate: coordinate,
                                       annotation: annotation)
                    
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
                        annotation = nil
                        dismiss()
                    }
                    .font(.subheadline)
                    .foregroundStyle(.black)
            
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            try await viewModel.uploadLocationWithCoordinate(
                                coordinate: coordinate,
                                activityId: activityId,
                                annotation: annotation,
                                userUid: container.currentUserService.currentUser?.id)
                            isSave.toggle()
                            annotation = nil
                            
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
    ConfirmationLocationView(coordinate: .startLocation, isSave: .constant(false), annotation: .constant(nil))
}
