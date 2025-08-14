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
    let annotation: MKPointAnnotation?
    
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
                Text("\(coordinate?.latitude ?? annotation?.coordinate.latitude ?? 0.0)")
                
                Spacer()
                
                Text("\(coordinate?.longitude ?? annotation?.coordinate.latitude ?? 0.0)")
                
            }
            .font(.subheadline)
            .padding(.horizontal)
        }
    }
}

#Preview {
    CoordinateInfoView(coordinate: .startLocation, annotation: nil)
}
