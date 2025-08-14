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
    @StateObject private var viewModel: TestMapViewModel
    
    init(activity: Activity) {
        
        self._activity = State(initialValue: activity)
        
        self._viewModel = StateObject(
            wrappedValue: TestMapViewModel(
                fetchLocatins:FetchLocationsForActivity(),
                activityUpdate: ActivityServiceUpdate(),
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
        .onChange(of: viewModel.isSaved) {
            Task {
                await viewModel.getLocation()
            }
        }
        .task {
            await viewModel.getLocation()
        }
        .sheet(item: $viewModel.sheetConfig) { config in
            switch config {
                
            case .confirmationLocation:
                ConfirmationLocationView(
                    activityId: activity.id,
                    coordinate: nil,
                    isSave: $viewModel.isSaved,
                    annotation: $viewModel.customAnnotation)
                    .presentationDetents([.height(340), .medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))

            case .locationsDetail:
                LocationsDetailView(
                    activity: viewModel.activity,
                    mapSeliction: $viewModel.selectedLocation,
                    getDirections: $viewModel.getDirections,
                    isUpdate: $viewModel.sheetConfig)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                    .presentationCornerRadius(12)
            
            case .locationUpdateOrSave:
                UpdateLocationView(
                    activityId: activity.id,
                    location: $viewModel.selectedLocation,
                    isSave: $viewModel.isSaved)
                    .presentationDetents([.height(340), .medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            }
        }
        .alert("Login problems", isPresented: $viewModel.isError) {
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
