//
//  LocationsDetailView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import SwiftUI
import MapKit

struct LocationsDetailView: View {
    
    @Binding var mapSeliction: Location?
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    @Binding var isUpdate: MapSheetConfig?
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = MapSearchViewModel()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                   
                    Text(mapSeliction?.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text((mapSeliction?.address ?? mapSeliction?.description) ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.leading)
                   
                }
                
                Spacer()
                
                Button {
                    mapSeliction = nil
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview availible", systemImage: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    viewModel.openMap(mapSeliction: mapSeliction)
                } label: {
                    Text("Open in map")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 110, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                if viewModel.currentUser?.id == mapSeliction?.ownerUid {
                    
                    if mapSeliction?.isSearch == true {
                        
                    } else {
                        
                        Button {
                            isUpdate = .locationUpdate
                        } label: {
                            Text("Update")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 110, height: 48)
                                .background(.yellow)
                                .cornerRadius(12)
                        }
                        
                    }
                    
                    Button {
                        getDirections = true
                        dismiss()
                    } label: {
                        Text("Get directions")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 110, height: 48)
                            .background(.blue)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: mapSeliction) {
            fetchLookAroundPreview()
        }
    }
}

#Preview {
    LocationsDetailView(mapSeliction: .constant(DeveloperPreview.location), getDirections: .constant(false), isUpdate: .constant(.locationsDetail))
}

extension LocationsDetailView {
    func fetchLookAroundPreview() {
        if let mapSeliction {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(coordinate: mapSeliction.coordinate)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
