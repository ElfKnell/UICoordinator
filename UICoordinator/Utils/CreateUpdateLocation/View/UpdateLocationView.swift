//
//  UpdateLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI
import MapKit

struct UpdateLocationView: View {
    
    var location: Location
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = UpdateLocationViewModel()
    //@Binding var isUpdate: Bool
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    FormInfoLocation(name: $viewModel.name, description: $viewModel.description, address: $viewModel.address)
                    
                    Divider()
                    
                    CoordinateInfoView(coordinate: location.coordinate)
                    
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
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundStyle(.black)
                        
                        Button {
                            
                            Task {
                                try await viewModel.deleteLocation(locationId: location.id)
                                dismiss()
                            }
                            
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            
                            //isUpdate.toggle()
                            
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
    UpdateLocationView(location: DeveloperPreview.location)
}
