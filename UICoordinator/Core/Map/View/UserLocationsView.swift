//
//  UserLocationsView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 29/03/2025.
//

import SwiftUI
import MapKit
import Firebase

struct UserLocationsView: View {
    
    var userId: String
    @StateObject var viewModel: UserLocationsViewModel

    init(userId: String) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: UserLocationsViewModelFactory.makeViewModel(userId: userId))
    }
    
    var body: some View {
        
        ZStack{
            
            Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
                ForEach(viewModel.locations, id: \.self) { location in
                    Annotation("", coordinate: location.coordinate) {
                        
                        MarkerView(
                            name: location.name,
                            isSelected: .constant(viewModel.mapSelection?.id == location.id)) {
                                viewModel.mapSelection = location
                            }
                    }
                }
                
                UserAnnotation()
                
                ForEach(viewModel.searchLoc, id: \.self) { item in
                    Marker(item.name, coordinate: item.coordinate)
                }
                
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .mapStyle(viewModel.styleMap.value)
            .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                viewModel.cameraPosition = .region(mapCameraUpdateContext.region)
                
                viewModel.fetchMoreLocationsByCurentUser()
            }
            
        }
        .navigationTitle("Map Locations")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $viewModel.navigatedLocation) { location in
            InfoView(activity: location)
        }
        .alert("Fetching error", isPresented: $viewModel.isError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(viewModel.messageError ?? "not discription")
        }
        .sheet(isPresented: $viewModel.isSelected) {
            LocationsDetailView(
                getDirectionsAction: {
                    if let selected = viewModel.mapSelection {
                        
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 0.35
                        ) {
                            withAnimation {
                                viewModel.navigatedLocation = selected
                                viewModel.mapSelection = nil
                            }
                        }
                    }
                },
                mapSeliction: $viewModel.mapSelection,
                isUpdate: $viewModel.sheetConfig)
                .presentationDetents([.medium, .height(550)])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationCornerRadius(12)
        }
        .safeAreaInset(edge: .bottom) {
            SearchLocationView(searchLocations: $viewModel.searchLoc, cameraPosition: $viewModel.cameraPosition)
        }
    }
}

#Preview {
    UserLocationsView(userId: "")
}
