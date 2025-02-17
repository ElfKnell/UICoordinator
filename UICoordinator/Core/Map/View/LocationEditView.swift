//
//  LocationEdit.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import SwiftUI
import MapKit

struct LocationEditView: View {
    
    @State var location: Location
    @StateObject var viewModel = EditLocationViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewMod: LocationViewModel
    @State private var showCreatColloqy = false
    
    var body: some View {
        Form {
            Section {
                TextField("Place name", text: $location.name)
                
                TextField("Description...", text: $location.description, axis: .vertical)
                    .font(.footnote)
            }
            
            Section {
                Button {
                    showCreatColloqy.toggle()
                } label: {
                    HStack {
                        Text("Creat new colloquy")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "plus.message")
                            .font(.title2)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .padding(7)
            }
            
            PhotoVideoLocationView(locationId: location.id)
            
            InformationLocationView(coordinate: location.coordinate)
            
        }
        .navigationTitle("Place details")
        .modifier(CornerRadiusModifier())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewMod.coordinatePosition = location.coordinate
        }
        .sheet(isPresented: $showCreatColloqy, content: {
            CreateColloquyView(location: location, colloquy: nil)
        })
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        try await viewModel.updateLocation(location)
                        dismiss()
                    }
                } label: {
                     Label("Save", systemImage: "checkmark.gobackward")
                }
                .opacity(location.name.isEmpty ? 0.3 : 1.0)
                .disabled(location.name.isEmpty)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
        }
    }
}

#Preview {
    LocationEditView(location: DeveloperPreview.location)
}
