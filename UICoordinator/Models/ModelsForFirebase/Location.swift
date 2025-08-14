//
//  Location.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 02/03/2024.
//

import FirebaseFirestoreSwift
import MapKit
import Firebase

struct Location: Identifiable, Codable, Hashable, MapSelectionProtocol {
    
    @DocumentID var locationId: String?
    let ownerUid: String
    var name: String
    var description: String
    var address: String?
    let timestamp: Timestamp
    var timeUpdate: Timestamp?
    let latitude: Double
    let longitude: Double
    var isSearch: Bool?
    
    let activityId: String
    
    var id: String {
        return locationId ?? NSUUID().uuidString
    }
    
    var user: User?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var regionCoordinate: MKCoordinateRegion {
        MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    }
}

extension Location {
    
    init(
        ownerUid: String = "",
        name: String,
        description: String = "",
        address: String? = nil,
        timestamp: Timestamp = Timestamp(),
        timeUpdate: Timestamp? = nil,
        latitude: Double,
        longitude: Double,
        isSearch: Bool? = nil,
        activityId: String = ""
    ) {
        self.locationId = nil
        self.ownerUid = ownerUid
        self.name = name
        self.description = description
        self.address = address
        self.timestamp = timestamp
        self.timeUpdate = timeUpdate
        self.latitude = latitude
        self.longitude = longitude
        self.isSearch = isSearch
        self.activityId = activityId
        self.user = nil
    }
}
