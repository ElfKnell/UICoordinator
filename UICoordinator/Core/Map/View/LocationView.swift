//
//  LocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI
import MapKit
import Firebase

struct LocationView: View {

    @StateObject var viewModel = LocationViewModel()

    @State private var isSave = false
    @State private var showSearch = false
    @State private var regionCamera: MapCameraPosition = .region(.startRegion)
    
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
                        }
                    }
                    
                    UserAnnotation()
                    
                    ForEach(viewModel.searchLoc, id: \.self) { item in
                        Marker(item.name, coordinate: item.coordinate)
                    }
                    
                    if let route = viewModel.route {
                        MapPolyline(route.polyline)
                            .stroke(.green, lineWidth: 7 )
                    }
                    
                }
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                    viewModel.coordinate = mapCameraUpdateContext.camera.centerCoordinate
                    regionCamera = .region(mapCameraUpdateContext.region)
                }
                
                SightView()
                
                VStack {
                    
                    HStack {
                        
                        Button {
                            Task {
                                try await viewModel.fetchUserForLocations()
                            }
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        .padding(.horizontal)
                        .font(.title2)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    VStack {
                        
                        if showSearch {
                            
                            TextField("Search ...", text: $viewModel.searchText)
                                .font(.subheadline)
                                .padding(12)
                                .background(.white)
                                .modifier(CornerRadiusModifier())
                                .padding()
                                .shadow(radius: 10)
                        }
                        
                        HStack {
                            Button {
                                viewModel.clean()
                                showSearch.toggle()
                            } label: {
                                Image(systemName: showSearch ? "xmark.circle" : "magnifyingglass.circle")
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
            .onAppear {
                Task {
                    try await viewModel.fetchUserForLocations()
                }
            }
            .onSubmit(of: .text) {
                Task {
                    try await viewModel.getResults(regionCamera)
                }
            }
            .onChange(of: isSave) {
                if isSave {
                    Task {
                        try await viewModel.fetchUserForLocations()
                    }
                }
            }
            .onChange(of: viewModel.getDirections, { oldValue, newValue in
                if newValue {
                    viewModel.fetchRoute()
                }
            })
            .onChange(of: viewModel.mapSelection, { oldValue, newValue in
                
                if newValue != nil {
                    viewModel.getDirections = false
                    viewModel.sheetConfig = .locationsDetail
                } else {
                    viewModel.sheetConfig = nil
                }
            })
            .sheet(item: $viewModel.sheetConfig, content: { config in
                switch config {
                case .confirmationLocation:
                    
                    ConfirmationLocationView(coordinate: viewModel.coordinate, isSave: $isSave)
                        .presentationDetents([.height(340), .medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))

                case .locationsDetail:
                    LocationsDetailView(mapSeliction: $viewModel.mapSelection, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
               
                case .locationUpdate:
                    if let location = viewModel.mapSelection {
                        UpdateLocationView(location: location)
                            .presentationDetents([.height(340), .medium])
                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    }
                }
            })
        }
    }
}

#Preview {
    LocationView()
}
