//
//  ActivityRoutesEditView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 06/10/2024.
//

import SwiftUI
import MapKit

struct ActivityEditView: View {
    
    @State var activity: Activity
    @State private var cameraPosition: MapCameraPosition
    @FocusState private var isSearch: Bool
    
    @StateObject var viewModel: ActivityEditViewModel
    
    init(activity: Activity, viewModelBilder: () -> ActivityEditViewModel =
         { ActivityEditViewModel(
            fetchLocatins: FetchLocationsForActivity(),
            activityUpdate: ActivityServiceUpdate())
    } ) {
        
        self.activity = activity
        let mv = viewModelBilder()
        self._viewModel = StateObject(wrappedValue: mv)
        self._cameraPosition = .init(wrappedValue: mv.initialCamera(for: activity))
    }
    
    var body: some View {
        MapReader { proxy in
            Map(position: $cameraPosition, selection: $viewModel.selectedPlace) {
                
                ForEach(viewModel.locations, id: \.self) { item in
                    
                    Marker(item.name, coordinate: item.coordinate)
                        .tint(.red)
                }
                
                UserAnnotation()
                
                ForEach(viewModel.searchLocations, id: \.self) { item in

                    Marker(item.name, coordinate: item.coordinate)
                }
                
                if !viewModel.routes.isEmpty {
                    ForEach(viewModel.routes, id: \.self) { route in
                        MapPolyline(route)
                            .stroke(.green, lineWidth: 5)
                    }
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .mapStyle(activity.mapStyle?.value ?? .standard)
            .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                cameraPosition = .region(mapCameraUpdateContext.region)
            }
            .onTapGesture(count: viewModel.isMark ? 1 : 2) { position in
                
                if let coordinate = proxy.convert(position, from: .local) {
                    viewModel.coordinate = coordinate
                    viewModel.sheetConfig = .confirmationLocation
                }
            }
            .task {
                await viewModel.getRoutes(activity: activity)
            }
            .onChange(of: viewModel.isSave) {
                Task {
                    await viewModel.getRoutes(activity: activity)
                }
            }
            .onChange(of: viewModel.selectedPlace, { oldValue, newValue in
                if let selectedPlace = viewModel.selectedPlace {
                    viewModel.selectedPlace = viewModel.verifyLocation(selectedLocation: selectedPlace)
                    viewModel.sheetConfig = .locationsDetail
                } else {
                    viewModel.sheetConfig = nil
                }
            })
            .onDisappear {
                Task {
                    try await viewModel.saveLocations(activityId: activity.id)
                }
            }
            .sheet(item: $viewModel.sheetConfig, content: { config in
                switch config {
                    
                case .confirmationLocation:
                    ConfirmationLocationView(coordinate: viewModel.coordinate, activityId: activity.id, isSave: $viewModel.isSave)
                        .presentationDetents([.height(340), .medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))

                case .locationsDetail:
                    LocationsDetailView(activity: activity, mapSeliction: $viewModel.selectedPlace, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
                
                case .locationUpdateOrSave:
                    UpdateLocationView(activityId: activity.id, location: $viewModel.selectedPlace, isSave: $viewModel.isSave)
                        .presentationDetents([.height(340), .medium])
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                }
            })
            .overlay(alignment: .top) {
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            ButtonBoolView(isCheck: $viewModel.isSettings, imageName: "gear")
                            
                            NavigationLink {
                                
                                InfoView(activity: activity)
                                
                            } label: {
                                Image(systemName: "camera.fill")
                                    .imageScale(.large)
                            }
                            .padding(7)
                            
                        }
                        
                        ButtonBoolView(isCheck: $viewModel.isMark, imageName: "cursorarrow.click.2")
                        
                    }
                    
                    Spacer()
                    
                }
               
            }
            .safeAreaInset(edge: .bottom) {
                
                if !viewModel.isMark && !viewModel.isSettings {
                    
                    VStack {
                        
                        HStack {
                            
                            Spacer()
                            
                            Button {
                                
                                Task {
                                    try await viewModel.saveRegione(cameraPosition.region, activityId: activity.id)
                                }
                                
                            } label: {
                                
                                Text("Set region")
                                
                            }
                            .padding()
                            .background(Color.yellow)
                            .opacity(0.7)
                            .modifier(CornerRadiusModifier())
                            .padding(.horizontal)
                            
                        }
                        
                        SearchLocationView(searchLocations: $viewModel.searchLocations, cameraPosition: cameraPosition)
                    }
                    
                } else if viewModel.isSettings {
                    
                    EditActivity(activity: $activity, isSettings: $viewModel.isSettings)
                    
                }
            }
        }
    }
}

#Preview {
    ActivityEditView(activity: DeveloperPreview.activity)
}
