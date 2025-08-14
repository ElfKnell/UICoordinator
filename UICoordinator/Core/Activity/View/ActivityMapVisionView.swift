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
    @State private var isSelected = false
    
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
        
        Map(position: $cameraPosition, selection: $viewModel.selectedPlace) {
            
            ForEach(viewModel.locations, id: \.self) { item in
                
                Marker(item.name, coordinate: item.coordinate)
                    .tint(.red)
            }
            
            UserAnnotation()
            
            ForEach(viewModel.searchLocations, id: \.self) { item in

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
        .task {
            await viewModel.getRoutes(activity: activity)
        }
        .onChange(of: viewModel.selectedPlace, { oldValue, newValue in
            if viewModel.selectedPlace != nil {
                isSelected = true
            } else {
                isSelected = false
            }
        })
        .sheet(isPresented: $isSelected, content: {
            LocationsDetailView(activity: activity, mapSeliction: $viewModel.selectedPlace, getDirections: $viewModel.getDirections, isUpdate: $viewModel.sheetConfig)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .overlay(alignment: .top) {
            
            HStack {
                
                NavigationLink {
                    
                    InfoView(activity: activity)
                    
                } label: {
                    Image(systemName: "info.circle")
                        .imageScale(.large)
                }
                .padding(7)
                
                Spacer()
                
            }
           
        }
        .safeAreaInset(edge: .bottom) {
            
            if !viewModel.isMark && !viewModel.isSettings {
                
                SearchLocationView(searchLocations: $viewModel.searchLocations, cameraPosition: $cameraPosition)
                
            }
        }
    }
}

#Preview {
    ActivityMapVisionView(activity: DeveloperPreview.activity)
}
