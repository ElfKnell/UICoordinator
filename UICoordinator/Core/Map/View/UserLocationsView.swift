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
    @StateObject var viewModel = UserLocationsViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                
                Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
                    ForEach(viewModel.locations) { location in
                        Annotation("", coordinate: location.coordinate) {
                            NavigationLink {
                                InfoView(activity: location)
                            } label: {
                                MarkerView(name: location.name)
                                    
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
                    
                    viewModel.fetchMoreLocationsByCurentUser(userId: userId)
                }
                
            }
            .navigationTitle("Map Locations")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchUserForLocations(userId: userId)
            }
            .onChange(of: viewModel.mapSelection) { oldValue, newValue in
                if viewModel.mapSelection != nil {
                    viewModel.isSelected = true
                } else {
                    viewModel.isSelected = false
                }
            }
            .sheet(isPresented: $viewModel.isSelected) {
                LocationsDetailView(mapSeliction: $viewModel.mapSelection, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            }
            .safeAreaInset(edge: .bottom) {
                SearchLocationView(searchLocations: $viewModel.searchLoc, cameraPosition: viewModel.cameraPosition)
            }
        }
    }
}

#Preview {
    UserLocationsView(userId: "")
}
