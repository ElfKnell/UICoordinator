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
                    
                    ForEach(viewModel.results, id: \.self) { item in
                        if (viewModel.routeDisplaying && item == viewModel.routeDistination) || !viewModel.routeDisplaying {
                            let markPlace = item.placemark
                            Marker(markPlace.name ?? "", coordinate: markPlace.coordinate)
                        }
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
                .onMapCameraChange { mapCameraUpdateContext in
                    viewModel.coordinate = mapCameraUpdateContext.camera.centerCoordinate
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
                    try await viewModel.getResults()
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
                    viewModel.sheetConfig = .locationsDetail
                }
            })
            .sheet(item: $viewModel.sheetConfig, content: { config in
                switch config {
                case .confirmationLocation:
                    
                    ConfirmationLocationView(coordinate: viewModel.coordinate, isSave: $isSave)
                        .presentationDetents([.height(300), .medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        .environmentObject(viewModel)

                case .locationsDetail:
                    LocationsDetailView(mapSeliction: $viewModel.mapSelection, getDirections: $viewModel.getDirections)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
                }
            })
        }
    }
}

#Preview {
    LocationView()
}
