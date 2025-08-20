//
//  ActivityUpdateProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import MapKit
import Foundation

protocol ActivityUpdateProtocol {
    
    func sreadActivity(_ activity: Activity, userId: String) async
    
    func incrementRepliesCount(activityId: String) async
    
    func updateLikeCount(activityId: String, countLikes: Int) async
    
    func updateActivityLocations(locationsId: [String], id: String) async throws
    
    func updateActivityCoordinate(region: MKCoordinateRegion, id: String) async throws
    
    func updateActivity(_ activity: Activity) async throws
}
