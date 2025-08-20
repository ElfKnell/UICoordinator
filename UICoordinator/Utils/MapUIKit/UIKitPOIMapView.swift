//
//  UIKitPOIMapView.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/08/2025.
//

import SwiftUI
import Firebase
import MapKit

struct UIKitPOIMapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    @Binding var showUserLocation: Bool
    @Binding var customAnnotation: MKPointAnnotation?
    @Binding var mapType: MKMapType
    @Binding var searchLocations: [Location]
    @Binding var savedLocations: [Location]
    @Binding var selectedLocation: Location?
    
    @Binding var routes: [MKRoute]
    
    @Binding var sheetConfig: MapSheetConfig?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.pointOfInterestFilter = .includingAll
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        mapView.setRegion(region, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = true
        
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        tapGesture.require(toFail: doubleTapGesture)
        
        mapView.addGestureRecognizer(doubleTapGesture)
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        if showUserLocation {
            if let userLocation = uiView.userLocation.location {
                let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                uiView.setRegion(region, animated: true)
            }
            
            DispatchQueue.main.async {
                self.showUserLocation = false
            }
        }
        
        uiView.mapType = mapType
        
        if uiView.region.center.latitude != region.center.latitude &&
            uiView.region.center.longitude != region.center.longitude {
            uiView.setRegion(region, animated: true)
        }
        
        context.coordinator.locationMap.removeAll()
        let userLocation = uiView.userLocation
        let annotationsToRemove = uiView.annotations.filter { $0 !== userLocation }
        uiView.removeAnnotations(annotationsToRemove)
        
        uiView.removeOverlays(uiView.overlays)
        
        if let poi = selectedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = poi.coordinate
            annotation.title = poi.name
            
            uiView.addAnnotation(annotation)
            uiView.selectAnnotation(annotation, animated: true)
        }
        
        if let customAnnotation {
            uiView.addAnnotation(customAnnotation)
            uiView.selectAnnotation(customAnnotation, animated: true)
        }
        
        for location in savedLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            uiView.addAnnotation(annotation)
            
            let key = CoordinateKey(annotation.coordinate)
            context.coordinator.locationMap[key] = location
        }
        
        for location in searchLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.name
            uiView.addAnnotation(annotation)
            
            let key = CoordinateKey(annotation.coordinate)
            if context.coordinator.locationMap[key] == nil {
                context.coordinator.locationMap[key] = location
            }
        }
        
        for (index, route) in routes.enumerated() {
            uiView.addOverlay(route.polyline)
            
            let midPoint = route.polyline.points()[route.polyline.pointCount / 2].coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = midPoint
            annotation.title = "\(index + 1)"
            uiView.addAnnotation(annotation)
            
            context.coordinator.routeColors[route.polyline] = Coordinator.color(for: index)
        }
    }
}
