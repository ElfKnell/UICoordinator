//
//  LocationsDetailView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/03/2024.
//

import SwiftUI
import MapKit

struct LocationsDetailView: View {
    
    var activity: Activity?
    var getDirectionsAction: () -> Void
    
    @Binding var mapSeliction: Location?
    @Binding var isUpdate: MapSheetConfig?
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    @StateObject var viewModel: LocationDetailViewModel
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    
    init(
        activity: Activity? = nil,
        getDirectionsAction: @escaping () -> Void,
        mapSeliction: Binding<Location?>,
        isUpdate: Binding<MapSheetConfig?>,
        viewModelBilder: @escaping () -> LocationDetailViewModel = {
            LocationDetailViewModel()
        }) {
        
        self.activity = activity
        self.getDirectionsAction = getDirectionsAction
        self._mapSeliction = mapSeliction
        self._isUpdate = isUpdate
        self._viewModel = StateObject(wrappedValue: viewModelBilder())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                   
                    Text(mapSeliction?.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    if let address = mapSeliction?.address {
                        Text(address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                   
                }
                
                Spacer()
                
                Button {
                    isUpdate = nil
                    mapSeliction = nil
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.horizontal)
            
            if let description = mapSeliction?.description {
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            
            Group {
                if let scene = lookAroundScene {
                    LookAroundPreview(initialScene: scene)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding(.horizontal)
                } else {
                    ContentUnavailableView("No preview availible", systemImage: "eye.slash")
                        .padding(.horizontal)
                }
            }
            
            Text("\(mapSeliction?.latitude ?? 0.0)° N; \(mapSeliction?.longitude ?? 0.0)° E")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            HStack(spacing: 24) {
                Button {
                    viewModel.openMap(mapSeliction: mapSeliction)
                } label: {
                    Text("Open in map")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
                
                if isUpdate != nil && viewModel.isCurrentUserUpdateLocation(mapSeliction: mapSeliction, activity: activity, currentUserId: container.currentUserService.currentUser?.id) {
                    
                    Button {
                        isUpdate = .locationUpdateOrSave
                    } label: {
                        Text(mapSeliction?.isSearch == true ? "Save" : "Update")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.orange)
                            .cornerRadius(12)
                    }
                }
                
                if let userId = mapSeliction?.ownerUid, !userId.isEmpty {
                    
                    Button {
                        getDirectionsAction()
                        isUpdate = nil
                    } label: {
                        Text(activity != nil ? "Get directions" : "Details")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.green)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
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
    LocationsDetailView(getDirectionsAction: {}, mapSeliction: .constant(nil), isUpdate: .constant(nil))
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
