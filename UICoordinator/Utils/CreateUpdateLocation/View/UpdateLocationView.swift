//
//  UpdateLocation.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI
import MapKit

struct UpdateLocationView: View {
    
    var activityId: String?
    
    @Binding var location: Location?
    @Binding var isSave: Bool
    
    @StateObject var viewModel: UpdateLocationViewModel
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    init(
        activityId: String? = nil,
        location: Binding<Location?>,
        isSave: Binding<Bool>,
        viewModelBilder: @escaping () -> UpdateLocationViewModel = {
            UpdateLocationViewModel(
                deleteLocation: DeleteLocation(),
                photoService: PhotoService(),
                videoService: VideoService())
        }) {
        
        self.activityId = activityId
        self._location = location
        self._isSave = isSave
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom, .horizontal])
                
                VStack {
                    
                    FormInfoLocation(name: $viewModel.name, description: $viewModel.description, address: $viewModel.address)
                    
                    Divider()
                    
                    if let coordinate = location?.coordinate {
                        CoordinateInfoView(coordinate: coordinate,
                                           annotation: nil)
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
                            
                            try await viewModel.saveLocation(
                                location,
                                activityId: activityId,
                                user: container.currentUserService.currentUser)
                            
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
