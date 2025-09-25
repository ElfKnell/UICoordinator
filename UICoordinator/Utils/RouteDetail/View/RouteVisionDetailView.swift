//
//  RouteVisionDetailView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/08/2025.
//

import SwiftUI
import MapKit

struct RouteVisionDetailView: View {
    
    @Binding var route: MKRoute?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                if let route {
                    
                    Section(header: Text("Route Details")
                        .font(.headline)) {
                        
                        Text("Distance: \(route.distance / 1000, specifier: "%.2f") km")
                        
                        Text("Estimated Time: \(route.expectedTravelTime / 60, specifier: "%.1f") mins")
                    }
                    
                    Section {
                        
                        HStack {
                            
                            Text("Transport Type")
                            
                            Spacer()
                            
                            Text(RouteTransportType(
                                mkTransportType: route.transportType)
                                .displayName)
                            
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    Section(header: Text("Step-by-Step Directions")
                        .font(.headline)) {
                        
                        List(route.steps, id: \.self) { step in
                            
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
            .navigationTitle("Info Route")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        
                        route = nil
                        dismiss()
                        
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundStyle(Color.primary)
                    .padding(.horizontal)
                    
                }
            }
        }
    }
}

#Preview {
    RouteVisionDetailView(route: .constant(nil))
}
