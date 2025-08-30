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
    var handleUpdate: () -> Void
    
    @Binding var location: Location?
    
    @StateObject var viewModel: UpdateLocationViewModel
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    init(
        activityId: String? = nil,
        handleUpdate: @escaping () -> Void,
        location: Binding<Location?>,
        viewModelBilder: @escaping () -> UpdateLocationViewModel = {
            UpdateLocationViewModel(
                deleteLocation: DeleteLocation(),
                photoService: PhotoService(),
                videoService: VideoService())
        }) {
        
        self.activityId = activityId
        self.handleUpdate = handleUpdate
        self._location = location
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
            .alert("Locations error", isPresented: $viewModel.isError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.messageError ?? "not discription")
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
                                    await viewModel.deleteLocation(locationId: location?.id, activityId: activityId)
                                    
                                    handleUpdate()
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
                            
                            await viewModel.saveLocation(
                                location,
                                activityId: activityId,
                                user: container.currentUserService.currentUser)
                            
                            
                            handleUpdate()
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
    UpdateLocationView(
        handleUpdate: { },
        location: .constant(DeveloperPreview.location)
    )
}
