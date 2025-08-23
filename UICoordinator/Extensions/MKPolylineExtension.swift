//
//  MKPolylineExtension.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 22/08/2025.
//

import Foundation
import MapKit

extension MKPolyline {
    
    var coordinates: [CLLocationCoordinate2D] {
        
        getCLCoordinates()
    }
    
    func toCoordinates() -> [Coordinate] {
        
        return getCLCoordinates().map { Coordinate($0) }
        
    }
    
    private func getCLCoordinates() -> [CLLocationCoordinate2D] {
        
        var coords = [CLLocationCoordinate2D](
            repeating: kCLLocationCoordinate2DInvalid,
            count: self.pointCount
        )
        
        self.getCoordinates(&coords, range: NSRange(location: 0, length: self.pointCount))
        return coords
        
    }
}
