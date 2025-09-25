//
//  RouteDetailView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 21/08/2025.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    
    var handleUpdate: () -> Void
    var handleDetete: () -> Void
    
    @Binding var route: RoutePair?
    
    @StateObject var viewModel: RouteDetailViewModel
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    init(
        handleUpdate: @escaping () -> Void,
        handleDetete: @escaping () -> Void,
        route: Binding<RoutePair?>,
        viewModelBilder: @escaping () -> RouteDetailViewModel = {
            RouteDetailViewModel()
        }) {
        
        self.handleUpdate = handleUpdate
        self.handleDetete = handleDetete
        self._route = route
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                if let route {
                    
                    Section(header: Text("Route Details")
                        .font(.headline)) {
                        
                        Text("Distance: \(route.mkRoute.distance / 1000, specifier: "%.2f") km")
                        
                        Text("Estimated Time: \(route.mkRoute.expectedTravelTime / 60, specifier: "%.1f") mins")
                    }
                    
                    Section {
                        
                        HStack {
                            
                            Picker("Transport Type", selection: $viewModel.selectedTransportType) {
                                Text("Default").tag(nil as RouteTransportType?)
                                ForEach(RouteTransportType.allCases) { option in
                                    Text(option.displayName).tag(option as RouteTransportType?)
                                }
                            }
                            
                        }
                        
                    }
                    
                    Section(header: Text("Step-by-Step Directions")
                        .font(.headline)) {
                        
                        List(route.mkRoute.steps, id: \.self) { step in
                            
                            if step.instructions != "" {
                                Text(step.instructions)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    Section(header: Text("Route Details").font(.headline)) {
                        
                        Text("Route NOT Found")
                            .font(.headline)
                    }
                    
                }
            }
            .padding(.horizontal)
            .navigationTitle("Info and Update Route")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.selectedTransportType = route?.storedRoute.transportType
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    HStack {
                        
                        Button {
                            
                            route = nil
                            dismiss()
                            
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .foregroundStyle(Color.primary)
                        .padding(.horizontal)
                        
                        Button {
                            
                            Task {
                                
                                handleDetete()
                                dismiss()
                                
                            }
                            
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .foregroundStyle(.red)
                        }
                        
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        
                        Task {

                            route?.storedRoute.transportType = viewModel.selectedTransportType ?? .automobile
                            handleUpdate()
                            
                            dismiss()
                            
                        }
                        
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

#Preview {
    RouteDetailView(
        handleUpdate: {},
        handleDetete: {},
        route: .constant(nil)
    )
}
