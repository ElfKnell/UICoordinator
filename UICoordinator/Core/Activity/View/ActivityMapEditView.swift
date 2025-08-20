//
//  TestMapView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/08/2025.
//

import SwiftUI
import MapKit

struct ActivityMapEditView: View {
    
    @State var activity: Activity
    @StateObject private var viewModel: ActivityMapEditViewModel
    
    init(activity: Activity) {
        
        self._activity = State(initialValue: activity)
        
        self._viewModel = StateObject(
            
            wrappedValue: ActivityMapEditViewModel(
                fetchLocatins:FetchLocationsForActivity(),
                activityUpdate: ActivityServiceUpdate(),
                serviceRoutes: ActivityRouters(
                    fetchingRoutes: FetchingRoutesService(),
                    createRoute: RouteCreateService()),
                activity: activity)
        )

    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            UIKitPOIMapView(
                region: $viewModel.region,
                showUserLocation: $viewModel.shouldUserLocation,
                customAnnotation: $viewModel.customAnnotation,
                mapType: $viewModel.mapType,
                searchLocations: $viewModel.searchLocations,
                savedLocations: $viewModel.savedLocations,
                selectedLocation: $viewModel.selectedLocation,
                routes: $viewModel.routes,
                sheetConfig: $viewModel.sheetConfig)
                .edgesIgnoringSafeArea(.all)
            
        }
        .onChange(of: viewModel.selectedLocation) { _, newValue in
            if let destination = newValue, viewModel.isSelectingDestination {
                Task {
                    await viewModel.buildRoute(to: destination)
                }
            }
        }
        .task {
            await viewModel.getLocation()
            await viewModel.loadRoutesIfNeeded()
        }
        .onDisappear {
            Task {
                await viewModel.saveLocations()
            }
        }
        .sheet(item: $viewModel.sheetConfig) { config in
            switch config {
                
            case .confirmationLocation:
                ConfirmationLocationView(
                    activityId: activity.id,
                    handleSave: {
                        Task {
                            await viewModel.getLocation()
                        }
                    },
                    annotation: $viewModel.customAnnotation)
                    .presentationDetents([.height(340), .medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))

            case .locationsDetail:
                LocationsDetailView(
                    activity: viewModel.activity,
                    getDirectionsAction: viewModel.startSelectingDestination,
                    mapSeliction: $viewModel.selectedLocation,
                    isUpdate: $viewModel.sheetConfig)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .presentationCornerRadius(12)
            
            case .locationUpdateOrSave:
                UpdateLocationView(
                    activityId: activity.id,
                    handleUpdate: {
                        Task {
                            await viewModel.getLocation()
                        }
                    },
                    location: $viewModel.selectedLocation)
                    .presentationDetents([.height(340), .medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
        }
        .alert("Error", isPresented: $viewModel.isError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "unknown error")
        }
        .overlay(alignment: .top) {
            
            HStack {
                Button {
                    
                    viewModel.isSettings.toggle()
                    
                } label: {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundStyle(.primary)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                if viewModel.isSelectingDestination {
                    Text("Select a location")
                        .font(.title)
                        .foregroundStyle(.primary)
                        .background(.clear)
                        .shadow(radius: 5)
                    
                    Spacer()
                }
                
                if viewModel.isLoadingRoutes {
                    
                    HStack {
                        
                        Text("Building routes...")
                            .font(.title)
                            .foregroundStyle(.primary)
                            .background(.clear)
                            .shadow(radius: 5)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.2)
                    }
                    
                    Spacer()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            
            if !viewModel.isSettings {
                
                VStack {
                    
                    HStack(alignment: .bottom) {
                        
                        HStack {
                            Button {
                                
                                viewModel.manuallySaveRegion()
                                
                            } label: {
                                
                                Image(systemName: "mappin.and.ellipse")
                                    .imageScale(.large)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                
                            }
                            
                            if viewModel.shouldRestoreSavedRegion {
                                
                                Button {
                                    
                                    viewModel.restoreSavedRegion()
                                    
                                } label: {
                                    
                                    Image(systemName: "arrow.uturn.backward.circle")
                                        .imageScale(.large)
                                        .foregroundStyle(.primary)
                                        .padding(10)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        VStack {
                            
                            if !viewModel.routes.isEmpty {
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
                            }
                            
                            NavigationLink {
                                
                                InfoView(activity: viewModel.activity)
                                
                            } label: {
                                Image(systemName: "camera")
                                    .imageScale(.large)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            
                            Button {
                                
                                viewModel.shouldUserLocation = true
                                
                            } label: {
                                Image(systemName: "location")
                                    .imageScale(.large)
                                    .foregroundStyle(.primary)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    SearchLocationView(
                        searchLocations: $viewModel.searchLocations,
                        cameraPosition: $viewModel.cameraPosition)
                    
                }
                
            } else if viewModel.isSettings {
                
                EditActivity(activity: $viewModel.activity, isSettings: $viewModel.isSettings)
                
            }
        }
    }
}

#Preview {
    ActivityMapEditView(activity: DeveloperPreview.activity)
}
