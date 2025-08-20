//
//  StoredRoute.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/08/2025.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase
import MapKit

struct StoredRoute: Identifiable, Codable, Hashable {
    
    @DocumentID var routeId: String?
    let activityId: String
    
    var startCoordinate: Coordinate
    var endCoordinate: Coordinate
    var coordinates: [Coordinate]
    
    var transportType: RouteTransportType
    var distance: Double
    var expectedTime: Double
    let createTime: Timestamp
    
    var id: String {
        return routeId ?? NSUUID().uuidString
    }
}

extension StoredRoute {
    
    init(activityId: String, route: MKRoute, transportType: RouteTransportType) {
        var coords = [CLLocationCoordinate2D](
            repeating: kCLLocationCoordinate2DInvalid,
            count: route.polyline.pointCount)
        route.polyline.getCoordinates(
            &coords,
            range: NSRange(
                location: 0,
                length: route.polyline.pointCount))
                
        let coordinateList = coords.map { Coordinate($0) }

        self.routeId = nil
        self.activityId = activityId
        self.startCoordinate = Coordinate(coords.first ?? .init())
        self.endCoordinate = Coordinate(coords.last ?? .init())
        self.coordinates = coordinateList
        self.transportType = transportType
        self.distance = route.distance
        self.expectedTime = route.expectedTravelTime
        self.createTime = Timestamp()
    }
}

extension StoredRoute {
    
    func toPolyline() -> MKPolyline {
        let coords = coordinates.map { $0.clCoordinate }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
}
