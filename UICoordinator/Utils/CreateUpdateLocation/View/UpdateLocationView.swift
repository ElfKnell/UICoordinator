//
//  UpdateLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI
import MapKit

struct UpdateLocationView: View {
    
    @Binding var location: Location?
    @Binding var isSave: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = UpdateLocationViewModel()
    var activityId: String?
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    FormInfoLocation(name: $viewModel.name, description: $viewModel.description, address: $viewModel.address)
                    
                    Divider()
                    
                    if let coordinate = location?.coordinate {
                        CoordinateInfoView(coordinate: coordinate)
                    }
                    
                }
                .padding()
                .background(.white)
                .modifier(CornerRadiusModifier())
                .padding()
            }
            .navigationTitle("Update Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
                viewModel.initInfo(location: location)
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        
                        Button {
                            location = nil
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundStyle(.black)
                        
                        if location?.locationId != nil {
                            Button {
                                
                                Task {
                                    try await viewModel.deleteLocation(locationId: location?.id, activityId: activityId)
                                    location = nil
                                    isSave.toggle()
                                    dismiss()
                                }
                                
                            } label: {
                                Image(systemName: "trash.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            
                            try await viewModel.saveLocation(location, activityId: activityId)
                            location = nil
                            isSave.toggle()
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }
}

#Preview {
    UpdateLocationView(location: .constant(DeveloperPreview.location), isSave: .constant(false))
}
