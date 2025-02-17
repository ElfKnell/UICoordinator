//
//  ActivityMapVisionView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/09/2024.
//

import SwiftUI
import MapKit

struct ActivityMapVisionView: View {
    
    @State var activity: Activity
    @State private var cameraPosition: MapCameraPosition
    @FocusState private var isSearch: Bool
    
    @StateObject var viewModel = ActivityMapViewModel()
    
    init(activity: Activity) {
        _cameraPosition = .init(wrappedValue: .region(activity.region ?? .startRegion))
        
        self.activity = activity
    }
    
    var body: some View {
        
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
        .onAppear {
            Task {
                try await viewModel.getLocations(activityId: activity.id)
            }
        }
        .onChange(of: viewModel.selectedPlace, { oldValue, newValue in
            if viewModel.selectedPlace != nil {
                viewModel.sheetConfig = .locationsDetail
            } else {
                viewModel.sheetConfig = nil
            }
        })
        .sheet(item: $viewModel.sheetConfig, content: { config in
            switch config {
                
            case .confirmationLocation:
                InfoActivityView(activity: activity, isInfo: $viewModel.sheetConfig)
                    .presentationDetents([.height(240), .medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))

            case .locationsDetail:
                LocationsDetailView(mapSeliction: $viewModel.selectedPlace, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                    .presentationDetents([.height(340)])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            
            case .locationUpdate:
                Text("None")
            }
        })
        .overlay(alignment: .top) {
            
            HStack {
                
                Button {
                    
                    viewModel.infoView()
                    
                } label: {
                    Image(systemName: "i.circle")
                        .imageScale(.large)
                }
                .padding(7)
                
                Spacer()
                
            }
           
        }
        .safeAreaInset(edge: .bottom) {
            
            if !viewModel.isMark && !viewModel.isSettings {
                
                VStack {
                    
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
                
            }
        }
    }
}

#Preview {
    ActivityMapVisionView(activity: DeveloperPreview.activity)
}
