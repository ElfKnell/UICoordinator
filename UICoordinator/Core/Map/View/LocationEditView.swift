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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationViewModel: LocationViewModel
    @State private var showCreatColloqy = false
    
    var body: some View {
        
        Form {
            
            Section(
                header: Text(location.name)
                    .font(.title2)
                    .foregroundStyle(Color.accentColor)
            ) {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    if let address = location.address {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("Address:")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            
                            Text(address)
                                .font(.headline)
                            
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("Description:")
                            .font(.body)
                            .foregroundStyle(.secondary)
                        
                        Text(location.description)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                    }
                }
            }
            
            Section {
                
                Button {
                    showCreatColloqy.toggle()
                } label: {
                    
                    HStack {
                        Text("Create new colloquy")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "plus.message")
                            .font(.title2)
                    }
                    
                }
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
            CreateColloquyView(
                isSaved: .constant(false),
                location: location
            )
        })
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            
        }
    }
}

#Preview {
    LocationEditView(location: DeveloperPreview.location)
}
