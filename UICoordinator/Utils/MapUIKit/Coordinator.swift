//
//  Coordinator.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 07/08/2025.
//

import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    
    var parent: UIKitPOIMapView
    var locationMap: [CoordinateKey: Location] = [:]
    
    var routeMap: [String: RoutePair] = [:]
    var routeColors: [MKPolyline: UIColor] = [:]
    
    var routeTransportTypes: [MKPolyline: MKDirectionsTransportType] = [:]
    
    init(_ parent: UIKitPOIMapView) {
        self.parent = parent
    }
    
    @objc
    func handleMapTap(_ gesture: UITapGestureRecognizer) {
        
        guard let mapView = gesture.view as? MKMapView else { return }
        let point = gesture.location(in: mapView)
        
        if mapView.hitTest(point, with: nil) is MKAnnotationView {
            return
        }
        
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        parent.customAnnotation = nil
        parent.selectedLocation = nil
        parent.sheetConfig = nil
        
        let key = CoordinateKey(coordinate)
        if let location = locationMap[key] {
            DispatchQueue.main.async {
                self.parent.selectedLocation = location
            }
            return
        }
        
        let poiRequest = MKLocalPointsOfInterestRequest(center: coordinate, radius: 50)
        poiRequest.pointOfInterestFilter = .includingAll
        
        let search = MKLocalSearch(request: poiRequest)
        search.start { response, error in
            if let item = response?.mapItems.first {
                DispatchQueue.main.async {
                    
                    let location = Location(
                        name: item.name ?? "",
                        description: item.placemark.description
                            .replacingOccurrences(of: "\\s*@.*", with: "", options: .regularExpression),
                        address: item.placemark.title,
                        latitude: item.placemark.coordinate.latitude,
                        longitude: item.placemark.coordinate.longitude,
                        isSearch: true
                    )
                    self.parent.selectedLocation = location
                    self.parent.sheetConfig = .locationsDetail
                }
            } else {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "My annotation"
                DispatchQueue.main.async {
                    self.parent.customAnnotation = annotation
                    self.parent.sheetConfig = .confirmationLocation
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if let title = annotation.title ?? "", let number = Int(title) {
            
            let identifier = "routeAnnotation"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if view == nil {
                
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view?.canShowCallout = true
                
            } else {
                view?.annotation = annotation
            }
            
            if let routePair = routeMap["\(number)"],
               let transportType = routeTransportTypes[routePair.mkRoute.polyline] {
                
                view?.image = CustomImage.generateCustomRouteImage(
                    number: number,
                    transportType: transportType
                )
            }
            
            view?.centerOffset = CGPoint(x: 0, y: -15)
            
            return view
        }
        
        let identifier = "marker"
        var view = mapView
            .dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }

        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let coordinate = view.annotation?.coordinate else { return }
        
        if let title = view.annotation?.title ?? "",
           let routePair = routeMap[title] {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.2) {
                    view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }
            }
            
            DispatchQueue.main.async {
                self.parent.selectedRoute = routePair
                self.parent.sheetConfig = .routeDetails
            }
            return
        }

        let key = CoordinateKey(coordinate)
        if let location = locationMap[key] {
            DispatchQueue.main.async {
                self.parent.selectedLocation = location
                self.parent.sheetConfig = .locationsDetail
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            
            renderer.strokeColor = routeColors[polyline] ?? .systemGreen
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    static func color(for index: Int) -> UIColor {
        
        let colors: [UIColor] = [.systemBlue, .systemRed, .systemGreen, .systemOrange, .systemPurple, .systemPink]
        return colors[index % colors.count]
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        DispatchQueue.main.async {
            self.parent.region = mapView.region
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if let title = view.annotation?.title ?? "",
           Int(title) != nil {
            
            UIView.animate(withDuration: 0.2) {
                view.transform = CGAffineTransform.identity
            }
        }
    }

}
