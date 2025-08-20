//
//  LocationColloquyView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 23/03/2024.
//

import SwiftUI
import MapKit

struct LocationColloquyView: View {
    
    var location: Location
    
    @State var mapCamera: MapCameraPosition
    @State private var navigatedLocation: Location?
    @State private var mapSelection: Location? {
        didSet {
            if mapSelection != nil {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
    @State private var isSelected: Bool = false
    @State private var sheetConfig: MapSheetConfig?
    
    init(location: Location) {
        self._mapCamera = State(wrappedValue: .region(location.regionCoordinate))
        self.location = location
    }
    
    var body: some View {
        

            Map(position: $mapCamera) {

                Annotation("", coordinate: location.coordinate) {
                    
                    MarkerView(
                        name: location.name,
                        isSelected: .constant(mapSelection?.id == location.id)) {
                            mapSelection = location
                        }
                }
            }
            .mapControls {
                MapCompass()
                MapPitchToggle()
            }
            .navigationTitle("Location on  the map")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .navigationDestination(item: $navigatedLocation, destination: { location in
                InfoView(activity: location)
            })
            .sheet(isPresented: $isSelected) {
                LocationsDetailView(
                    getDirectionsAction: {
                        if let selected = mapSelection {
                            
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.35
                            ) {
                                withAnimation {
                                    navigatedLocation = selected
                                    mapSelection = nil
                                }
                            }
                        }
                    },
                    mapSeliction: $mapSelection,
                    isUpdate: $sheetConfig)
                    .presentationDetents([.medium])
                    .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                    .presentationCornerRadius(12)
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    BackButtonView()
                }
                
            }
        }
}

#Preview {
    LocationColloquyView(location: DeveloperPreview.location)
}
