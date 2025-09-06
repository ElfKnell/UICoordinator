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
    
    init(activity: Activity, viewModelBuilder: () -> ActivityVisionViewModel =
         { ActivityVisionViewModel(
            fetchLocations: FetchLocationsForActivity(),
            activityUpdate: ActivityServiceUpdate(),
            serviceRoutes: ActivityFetchingRoutes(
                fetchingRoutes: FetchingRoutesService()))
    } ) {
        
        self.activity = activity
        let mv = viewModelBuilder()
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
                    
                    Annotation("", coordinate: midCoordinate) {
                        
                        Button {
                            viewModel.selectedRoute = route
                            viewModel.sheetConfig = .routeDetails
                        } label: {
                            
                            AnimatedRouteMarker(
                                index: index,
                                transportTypeRout: route.transportType
                            )
                            
                        }
                    }
                    
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
        .onChange(of: viewModel.selectedPlace) { _, newValue in
            
            if viewModel.selectedPlace == newValue &&
                viewModel.selectedPlace != nil {
                
                viewModel.sheetConfig = .locationDetails
                
            } else {
                
                viewModel.sheetConfig = nil
                
            }
            
        }
        .onChange(of: viewModel.selectedPlace) { _, newValue in
            
            if let destination = newValue, viewModel.isSelectingDestination {
                
                Task {
                    await viewModel.buildRoute(
                        to: destination,
                        activity: activity
                    )
                }
                
            }
        }
        .sheet(item: $viewModel.sheetConfig, content: { config in
            switch config {
            case .locationDetails:
                LocationsDetailView(
                    activity: activity,
                    getDirectionsAction: viewModel.startSelectingDestination,
                    mapSeliction: $viewModel.selectedPlace,
                    isUpdate: .constant(nil))
                    .presentationDetents([.medium, .height(550)])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .medium))
                    .presentationCornerRadius(12)
            case .routeDetails:
                RouteVisionDetailView(
                    route: $viewModel.selectedRoute)
                    .presentationDetents([.medium, .height(550)])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .medium))
                    .presentationCornerRadius(12)
            }
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
