//
//  ActivityMapView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/07/2024.
//

import SwiftUI
import MapKit

struct ActivityMapEditView: View {
    
    @State var activity: Activity
    @State private var cameraPosition: MapCameraPosition
    @FocusState private var isSearch: Bool
    
    @StateObject var viewModel = ActivityMapViewModel()
    
    init(activity: Activity) {
        _cameraPosition = .init(wrappedValue: .region(activity.region ?? .startRegion))

        self.activity = activity
    }
    
    var body: some View {
        MapReader { proxy in
            Map(position: $cameraPosition, selection: $viewModel.selectedPlace) {
                
                ForEach(viewModel.locations, id: \.self) { item in
                    
                    Marker(item.name, coordinate: item.coordinate)
                        .tint(.red)
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
            .onMapCameraChange(frequency: .onEnd) { mapCameraUpdateContext in
                cameraPosition = .region(mapCameraUpdateContext.region)
            }
            .onTapGesture(count: viewModel.isMark ? 1 : 2) { position in
                
                if let coordinate = proxy.convert(position, from: .local) {
                    viewModel.coordinate = coordinate
                    viewModel.sheetConfig = .confirmationLocation
                }
            }
            .onAppear {
                Task {
                    try await viewModel.getLocations(activityId: activity.id)
                }
            }
            .onChange(of: viewModel.isSave) {
                if viewModel.isSave {
                    Task {
                        try await viewModel.getLocations(activityId: activity.id)
                    }
                }
            }
            .onChange(of: viewModel.selectedPlace, { oldValue, newValue in
                if viewModel.selectedPlace != nil {
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
                    LocationsDetailView(mapSeliction: $viewModel.selectedPlace, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                        .presentationDetents([.height(340)])
                        .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                        .presentationCornerRadius(12)
                
                case .locationUpdate:
                    if let location = viewModel.selectedPlace {
                        UpdateLocationView(location: location)
                            .presentationDetents([.height(340), .medium])
                            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    }
                }
            })
            .overlay(alignment: .top) {
                
                HStack {
                    
                    VStack {
                        
                        ButtonBoolView(isCheck: $viewModel.isSettings, imageName: "gear")
                        
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
                        
                        HStack {
                            
                            TextField("Search", text: $viewModel.searctText)
                                .textFieldStyle(.roundedBorder)
                                .modifier(CornerRadiusModifier())
                                .focused($isSearch)
                                .overlay(alignment: .trailing) {
                                    
                                    if isSearch {
                                        
                                        Button {
                                            viewModel.searctText = ""
                                            isSearch = false
                                            
                                        } label: {
                                            
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red)
                                            
                                        }
                                        .offset(x: -5)
                                    }
                                }
                                .onSubmit {
                                    
                                    Task {
                                        try await viewModel.getResults(cameraPosition, searchText: viewModel.searctText)
                                        
                                        viewModel.searctText = ""
                                    }
                                    
                                }
                            
                            
                            if !viewModel.searchLoc.isEmpty {
                                
                                Button {
                                    
                                    viewModel.clean()
                                    
                                } label: {
                                    
                                    Image(systemName: "mappin.slash.circle.fill")
                                        .imageScale(.large)
                                }
                                .foregroundStyle(.white)
                                .padding(5)
                                .background(.red)
                                .clipShape(.circle)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    
                } else if viewModel.isSettings {
                    
                    EditActivity(activity: $activity, isSettings: $viewModel.isSettings)
                    
                }
            }
        }
    }
}

#Preview {
    ActivityMapEditView(activity: DeveloperPreview.activity)
}
