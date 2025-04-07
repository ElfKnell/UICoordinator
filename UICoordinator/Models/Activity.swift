//
//  Activity.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/04/2024.
//

import Firebase
import FirebaseFirestoreSwift
import MapKit

struct Activity: Identifiable, Codable, Hashable, MapSelectionProtocol {
    
    @DocumentID var activityId: String?
    let ownerUid: String
    var name: String
    var typeActivity: ActivityType
    var description: String
    let time: Timestamp
    var udateTime: Timestamp?
    var status: Bool
    var latitude: Double?
    var longitude: Double?
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    var likes: Int
    var mapStyle: ActivityMapStyle?
    var repliesCount: Int?
    
    var locationsId: [String]
    
    var id: String {
        return activityId ?? NSUUID().uuidString
    }
    
    var region: MKCoordinateRegion? {
        if let latitude, let longitude, let latitudeDelta, let longitudeDelta {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else {
            return nil
        }
    }
    
    var locations: [Location]?
    var user: User?

}
