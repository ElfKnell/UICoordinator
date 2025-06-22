//
//  CreateRouter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/04/2025.
//

import MapKit
import SwiftUI

class CreateRouter: CreateRouterProtocol {
    
    @AppStorage("typeMap") private var typeMap: MapTransportType = .automobile
    
    func getRouter(coordinate: CLLocationCoordinate2D?, mapSelection: Location?) async throws -> MKRoute? {
        
        if let mapSelection {
            
            var route: MKRoute?
            let request = MKDirections.Request()
            let mapItem: MKMapItem = .init(placemark: .init(coordinate: mapSelection.coordinate))
            request.source = mapItem
            
            if mapItem.placemark.coordinate.latitude == coordinate?.latitude && mapItem.placemark.coordinate.longitude == coordinate?.longitude {
                
                guard let userLocation = try await getUserLocation() else { return nil }
                request.destination = MKMapItem(placemark: .init(coordinate: userLocation))
                
            } else  if let coordinateRouter = coordinate {
                request.destination = MKMapItem(placemark: .init(coordinate: coordinateRouter))
            } else {
                guard let userLocation = try await getUserLocation() else { return  nil }
                request.destination = MKMapItem(placemark: .init(coordinate: userLocation))
            }
            
            request.transportType = typeMap.value
            let result = try await MKDirections(request: request).calculate()
            route = result.routes.first
            
            return route
        } else {
            return nil
        }
    }
    
    private func getUserLocation() async throws -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            let update = try await updates.first { $0.location?.coordinate != nil }
            return update?.location?.coordinate
        } catch {
            print("ERROR \(error.localizedDescription)")
            return nil
        }
    }
}
