//
//  AnimatedRouteMarker.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/08/2025.
//

import SwiftUI
import MapKit

struct AnimatedRouteMarker: View {
    
    let index: Int
    let transportTypeRout: MKDirectionsTransportType
    
    var transportType: RouteTransportType {
        RouteTransportType(mkTransportType: transportTypeRout)
    }
    
    @State private var animate = false
    
    var body: some View {
        
        VStack(spacing: 4) {
            
            Image(systemName: transportType.iconName)
                .foregroundStyle(.blue)
                .font(.system(size: 20))
                .scaleEffect(animate ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: animate)
            
            Text("\(index + 1)")
                .font(.caption)
                .padding(6)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            
        }
        .onAppear {
            
            animate = true
            
        }
    }
}

#Preview {
    AnimatedRouteMarker(
        index: 0,
        transportTypeRout: .automobile
    )
}
