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
    
    @StateObject var viewModel: ActivityVisionViewModel
    
    init(activity: Activity, viewModelBilder: () -> ActivityVisionViewModel =
         { ActivityVisionViewModel(
            fetchLocatins: FetchLocationsForActivity(),
            activityUpdate: ActivityServiceUpdate(),
            serviceRoutes: ActivityRouters(
                fetchingRoutes: FetchingRoutesService(),
                createRoute: RouteCreateService()))
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
            
            if !viewModel.routes.isEmpty {
                ForEach(Array(viewModel.routes.enumerated()), id: \.1) { index, route in
                    MapPolyline(route)
                        .stroke(.green, lineWidth: 5)
                    
                    let midCoordinate = viewModel.midpoint(of: route.polyline)
                    
                    Marker("\(index + 1)", coordinate: midCoordinate)
                        .tint(.black)
                }
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
            await viewModel.getLocation(activityId: activity.id)
            await viewModel.loadRoutesIfNeeded(activityId: activity.id)
        }
        .onChange(of: viewModel.selectedPlace) {
            if viewModel.selectedPlace != nil {
                viewModel.isSelected = true
            } else {
                viewModel.isSelected = false
            }
        }
        .onChange(of: viewModel.selectedPlace) { _, newValue in
            if let destination = newValue, viewModel.isSelectingDestination {
                Task {
                    await viewModel.buildRoute(to: destination)
                }
            }
        }
        .sheet(isPresented: $viewModel.isSelected, content: {
            
            LocationsDetailView(
                activity: activity,
                getDirectionsAction: viewModel.startSelectingDestination,
                mapSeliction: $viewModel.selectedPlace,
                isUpdate: $viewModel.sheetConfig)
                .presentationDetents([.medium])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .presentationCornerRadius(12)
        })
        .overlay(alignment: .top) {
            
            HStack {
                
                VStack {
                    
                    NavigationLink {
                        
                        InfoView(activity: activity)
                        
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(7)
                    
                    Button {
                        
                        viewModel.clean()
                        
                    } label: {
                        Image(systemName: "eraser.line.dashed")
                            .imageScale(.large)
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(7)
                }
                
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
