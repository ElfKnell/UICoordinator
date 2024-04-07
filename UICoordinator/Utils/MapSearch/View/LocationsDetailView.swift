//
//  LocationsDetailView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import SwiftUI
import MapKit

struct LocationsDetailView: View {
    
    @Binding var mapSeliction: MKMapItem?
    @State private var lookAroundScene: MKLookAroundScene?
    @Binding var getDirections: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                   
                    Text(mapSeliction?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                    Text(mapSeliction?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
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
                ContentUnavailableView("No preview availible", image: "eye.slash")
            }
            
            HStack(spacing: 24) {
                Button {
                    if let mapSeliction {
                        mapSeliction.openInMaps()
                    }
                } label: {
                    Text("Open in map")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                Button {
                    getDirections = true
                    dismiss()
                } label: {
                    Text("Get directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
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
    LocationsDetailView(mapSeliction: .constant(.init()), getDirections: .constant(false))
}

extension LocationsDetailView {
    func fetchLookAroundPreview() {
        if let mapSeliction {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSeliction)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
