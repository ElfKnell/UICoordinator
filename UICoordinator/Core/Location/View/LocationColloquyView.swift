//
//  LocationColloquyView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2024.
//

import SwiftUI
import MapKit

struct LocationColloquyView: View {
    @State var mapCamera: MapCameraPosition
    var location: Location
    
    init(location: Location) {
        self._mapCamera = State(wrappedValue: .region(location.regionCoordinate))
        self.location = location
    }
    
    var body: some View {
        NavigationStack {
            Map(position: $mapCamera) {
                Annotation("", coordinate: location.coordinate) {
                    NavigationLink {
                        
                    } label: {
                        MarkerView(name: location.name)
                    }
                }
            }
            .overlay {
                VStack {
                    HStack {
                        BackButtonView()
                            .font(.largeTitle)
                            .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
            }
        }
    }
}

#Preview {
    LocationColloquyView(location: DeveloperPreview.location)
}
