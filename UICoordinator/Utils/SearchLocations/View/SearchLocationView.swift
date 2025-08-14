//
//  SearchLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 04/04/2025.
//

import SwiftUI
import MapKit

struct SearchLocationView: View {
    
    @Binding var searchLocations: [Location]
    @Binding var cameraPosition: MapCameraPosition
    
    @StateObject private var viewModel = SearchLocationViewModel()
    @FocusState private var isSearch: Bool
    
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
                            
                            searchLocations = await viewModel.getLocations(cameraPosition)
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
    SearchLocationView(searchLocations: .constant([]), cameraPosition: .constant(.region(.startRegion)))
}
