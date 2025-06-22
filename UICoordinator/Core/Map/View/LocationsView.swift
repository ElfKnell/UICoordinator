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
            createRouter: CreateRouter(),
            fetchLocations: FetchLocations(fetchLocationByUser: FetchLocationsFromFirebase()))
    }) {
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
                    
                    ForEach(viewModel.locations) { location in
                        Annotation("", coordinate: location.coordinate) {
                            
                            NavigationLink {
                                
                                LocationEditView(location: location)
                                    .environmentObject(viewModel)
                                
                            } label: {
                                
                                MarkerView(name: location.name)
                                    
                            }
                            .contextMenu {
                                Button("Preview") {
                                    viewModel.mapSelection = location
                                }
                                
                                Button("Update") {
                                    viewModel.updateLocation(location)
                                }
                            }
                        }
                    }
                    
                    UserAnnotation()
                    
                    ForEach(viewModel.searchLoc, id: \.self) { item in
                        Marker(item.name, coordinate: item.coordinate)
                    }
                    
                    if let route = viewModel.route {
                        MapPolyline(route.polyline)
                            .stroke(viewModel.routerColor, lineWidth: 5)
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
                
                SightView()
                
                VStack {
                    
                    HStack {
                        
                        Button {
                            viewModel.clean()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .padding()
                        .font(.title2)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    VStack {
                        
                        if viewModel.showSearch {
                            
                            SearchLocationView(searchLocations: $viewModel.searchLoc, cameraPosition: viewModel.cameraPosition)
                        }
                        
                        HStack {
                            Button {
                                viewModel.showSearch.toggle()
                            } label: {
                                Image(systemName: viewModel.showSearch ? "xmark.circle" : "magnifyingglass.circle")
                                    .font(.largeTitle)
                                    .padding(.bottom)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.sheetConfig = .confirmationLocation
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .font(.largeTitle)
                            .padding(.bottom)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Map Locations")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchLocationsByCurrentUser(userId: container.authService.userSession?.uid)
            }
            .onChange(of: viewModel.isSave) {
                Task {
                    await viewModel.addLocation(userId: container.authService.userSession?.uid)
                }
            }
            .onChange(of: viewModel.getDirections, { oldValue, newValue in
                if newValue {
                    viewModel.fetchRoute()
                }
            })
            .onChange(of: viewModel.mapSelection, { oldValue, newValue in

                if let selectedPlace = viewModel.mapSelection {

                    viewModel.mapSelection = viewModel.verifyLocation(selectedLocation: selectedPlace)
                    
                } else {
                    viewModel.sheetConfig = nil
                }
            })
            .sheet(item: $viewModel.sheetConfig) { config in
                switch config {
                case .confirmationLocation:
                    
                    ConfirmationLocationView(coordinate: viewModel.coordinate, isSave: $viewModel.isSave)
                        .presentationDetents([.height(340), .medium])

                case .locationsDetail:
                    
                    LocationsDetailView(mapSeliction: $viewModel.mapSelection, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
               
                case .locationUpdateOrSave:
                    
                    UpdateLocationView(location: $viewModel.mapSelection, isSave: $viewModel.isSave)
                        .presentationDetents([.height(350), .medium])
                        
                }
            }
        }
    }
}

#Preview {
    LocationsView()
}
