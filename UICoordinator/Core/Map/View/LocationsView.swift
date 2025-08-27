//
//  LocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI
import MapKit
import Firebase

struct LocationsView: View {

    @StateObject var viewModel: LocationViewModel
    @EnvironmentObject var container: DIContainer
    
    init(viewModelBilder: @escaping () -> LocationViewModel = {
        LocationViewModel(
            locationService: FetchLocationFromFirebase(),
            fetchLocations: FetchLocationsFromFirebase())
    }) {
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            MapReader { proxy in
                
                Map(position: $viewModel.cameraPosition,
                    selection: $viewModel.mapSelection) {
                    
                    ForEach(viewModel.locations, id: \.self) { item in
                        
                        Annotation("", coordinate: item.coordinate) {
                            
                            MarkerView(
                                name: item.name,
                                isSelected: .constant(viewModel.mapSelection?.id == item.id)) {
                                    viewModel.tappedOnAnnotation = true
                                    viewModel.mapSelection = item
                                    
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
                    viewModel.coordinate = mapCameraUpdateContext.camera.centerCoordinate
                    viewModel.cameraPosition = .region(mapCameraUpdateContext.region)
                    
                    viewModel.fetchMoreLocationsByCurentUser(userId: container.currentUserService.currentUser?.id)
                    
                }
                .onTapGesture(count: 1) { position in
                    
                    if viewModel.tappedOnAnnotation {
                        viewModel.tappedOnAnnotation = false
                        return
                    }
                    
                    if let coordinate = proxy.convert(position, from: .local) {
                        if viewModel.mapSelection == nil {
                            viewModel.handleTap(on: coordinate)
                        }
                    }
                }
                .onTapGesture(count: 2) { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        guard let region = viewModel.cameraPosition.region else { return }
                        let latitude = region.span.latitudeDelta * 0.7
                        let longitude = region.span.longitudeDelta * 0.7
                        
                        let newRegion = MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(
                                latitudeDelta: latitude,
                                longitudeDelta: longitude))
                        
                        withAnimation {
                            viewModel.cameraPosition = .region(newRegion)
                        }
                    }
                }
                .task {
                    await viewModel
                        .fetchLocationsByCurrentUser(
                            userId: container
                                .authService
                                .userSession?.uid)
                }
                .onChange(of: viewModel.mapSelection) { oldValue, newValue in

                    if let selectedPlace = viewModel.mapSelection {

                        viewModel.mapSelection = viewModel
                            .verifyLocation(
                                selectedLocation: selectedPlace)
                        
                    } else {
                        viewModel.sheetConfig = nil
                    }
                }
                
            }
            .navigationTitle("Map Locations")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $viewModel.navigatedLocation) { location in
                LocationEditView(location: location)
                    .environmentObject(viewModel)
            }
            .onChange(of: viewModel.isDeleted) {
                Task {
                    
                    await viewModel
                        .updateLocationsByCurrentUser(
                            userId: container
                                .authService
                                .userSession?.uid)
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    
                    VStack {
                        
                        if viewModel.showSearch {
                            
                            SearchLocationView(searchLocations: $viewModel.searchLoc, cameraPosition: $viewModel.cameraPosition)
                        }
                        
                        HStack {
                            
                            Button {
                                viewModel.showSearch.toggle()
                            } label: {
                                Image(systemName: viewModel.showSearch ? "xmark.circle" : "magnifyingglass.circle")
                                    .font(.title)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.clean()
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .imageScale(.large)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                        }
                        
                    }
                    
                }
                .padding()
            }
            .sheet(item: $viewModel.sheetConfig) { config in
                switch config {
                case .confirmationLocation:
                    
                    ConfirmationLocationView(
                        handleSave: {
                            viewModel.addLocation(
                                userId: container.authService.userSession?.uid)
                        },
                        annotation: $viewModel.customAnnotation
                    )
                        .presentationDetents([.height(340), .medium])

                case .locationsDetail:
                    
                    LocationsDetailView(
                        getDirectionsAction: {
                            if let selected = viewModel.mapSelection {
                                viewModel.sheetConfig = nil
                                
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 0.35
                                ) {
                                    withAnimation {
                                        viewModel.navigatedLocation = selected
                                    }
                                }
                                viewModel.mapSelection = nil
                            }
                        },
                        mapSeliction: $viewModel.mapSelection,
                        isUpdate: $viewModel.sheetConfig
                    )
                        .presentationDetents([.medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        .presentationCornerRadius(12)
               
                case .locationUpdateOrSave:
                    
                    UpdateLocationView(
                        handleUpdate: {
                            viewModel.updateOrDeleteLocation(
                                userId: container.authService.userSession?.uid)
                        },
                        location: $viewModel.mapSelection
                    )
                        .presentationDetents([.height(350), .medium])
                        
                case .routeDetails:
                    Text("Route details view is under construction")
                        .padding()
                        .presentationDetents([.medium])
                }

            }
        }
    }
}

#Preview {
    LocationsView()
}
