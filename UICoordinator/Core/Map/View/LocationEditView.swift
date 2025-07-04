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
    @StateObject var viewModel: EditLocationViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showCreatColloqy = false
    
    init(location: Location,
         viewModelBilder: @escaping () -> EditLocationViewModel = {
        EditLocationViewModel(
            serviseLocation: LocationService())
    }) {
        self.location = location
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
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
            
            Section {
                PhotoVideoLocationView(location: location)
            }
            
            InformationLocationView(coordinate: location.coordinate)
            
        }
        .navigationTitle("Place details")
        .modifier(CornerRadiusModifier())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            locationViewModel.coordinatePosition = location.coordinate
        }
        .sheet(isPresented: $showCreatColloqy, content: {
            CreateColloquyView(location: location)
        })
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                
                Button {
                    Task {
                        await viewModel.updateLocation(location)
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
