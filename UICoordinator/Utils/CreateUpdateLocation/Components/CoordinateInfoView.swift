//
//  CoordinateInfoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI
import MapKit

struct CoordinateInfoView: View {
    
    let coordinate: CLLocationCoordinate2D?
    
    var body: some View {
        
        VStack {
            
            Text("Coordinates")
                .font(.title3)
            
            HStack {
                Text("Latitude:")
                
                Spacer()
                
                Text("Longitude:")
                
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            HStack {
                Text("\(coordinate?.latitude ?? 0.0)")
                
                Spacer()
                
                Text("\(coordinate?.longitude ?? 0.0)")
                
            }
            .font(.subheadline)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CoordinateInfoView(coordinate: .startLocation)
}
