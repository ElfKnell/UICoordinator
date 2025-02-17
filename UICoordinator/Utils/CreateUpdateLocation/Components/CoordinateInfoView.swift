//
//  CoordinateInfoView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import SwiftUI
import MapKit

struct CoordinateInfoView: View {
    
    let coordinate: CLLocationCoordinate2D
    
    var body: some View {
        
        VStack {
            
            Text("Coordinats")
                .font(.title3)
            
            HStack {
                Text("Lanitude:")
                
                Spacer()
                
                Text("Longitude:")
                
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            HStack {
                Text("\(coordinate.latitude)")
                
                Spacer()
                
                Text("\(coordinate.longitude)")
                
            }
            .font(.subheadline)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CoordinateInfoView(coordinate: .startLocation)
}
