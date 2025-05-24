//
//  InformationLocationView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 03/03/2024.
//

import SwiftUI
import MapKit

struct InformationLocationView: View {
    let coordinate: CLLocationCoordinate2D
    
    @StateObject var viewModel = InformationLocationViewModel()
    
    var body: some View {
        
        Section("Nearby...") {
            
            switch viewModel.loadingState {
            case .loading:
                Text("Loading...")
            case .loaded:
                List(viewModel.pages, id: \.pageid) { page in
                    Text(page.title)
                        .font(.headline)
                    + Text(": ")
                    + Text(page.description)
                        .italic()
                }
                
                WikipediaAttributionView()
                
            case .failed:
                Text("Please try again later.")
            }
            
        }
        .task {
            await viewModel.fetchNearbyPlaces(coordinate: coordinate)
        }
    }
}

#Preview {
    InformationLocationView(coordinate: .startLocation)
}
