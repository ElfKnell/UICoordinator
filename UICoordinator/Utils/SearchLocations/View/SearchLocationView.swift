//
//  SearchLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/04/2025.
//

import SwiftUI
import MapKit

struct SearchLocationView: View {
    
    @StateObject private var viewModel = SearchLocationViewModel()
    @EnvironmentObject var container: DIContainer
    @FocusState private var isSearch: Bool
    @Binding var searchLocations: [Location]
    
    var cameraPosition: MapCameraPosition
    
    var body: some View {
        VStack {
            
            HStack {
                
                TextField("Search", text: $viewModel.searctText)
                    .textFieldStyle(.roundedBorder)
                    .modifier(CornerRadiusModifier())
                    .focused($isSearch)
                    .overlay(alignment: .trailing) {
                        
                        if isSearch {
                            
                            Button {
                                viewModel.searctText = ""
                                isSearch = false
                                
                            } label: {
                                
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                
                            }
                            .offset(x: -5)
                        }
                    }
                    .onSubmit {
                        
                        Task {
                            
                            searchLocations = await viewModel.getLocations(cameraPosition, currentUserId: container.currentUserService.currentUser?.id)
                            viewModel.searctText = ""
                            
                        }
                        
                    }
                
                
                if !searchLocations.isEmpty {
                    
                    Button {
                        
                        searchLocations.removeAll()
                        viewModel.searctText = ""
                        
                    } label: {
                        
                        Image(systemName: "mappin.slash.circle.fill")
                            .imageScale(.large)
                    }
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.red)
                    .clipShape(.circle)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

#Preview {
    SearchLocationView(searchLocations: .constant([]), cameraPosition: .region(.startRegion))
}
