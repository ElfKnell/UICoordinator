//
//  ConfirmationLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 05/03/2024.
//

import Foundation
import Firebase
import MapKit
import FirebaseCrashlytics

class ConfirmationLocationViewModel: LocationService, ObservableObject {
    
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    
    @Published var messageError: String?
    @Published var isError = false
    
    @MainActor
    func uploadLocationWithCoordinate(activityId: String?,
                                      annotation: MKPointAnnotation?,
                                      userUid: String?) async {
        
        messageError = nil
        isError = false
        
        do {
            
            var corectAddress: String?
            guard let userUid else { return }
            if self.address != "" {
                corectAddress = address
            }
            
            guard let coordinate = annotation?.coordinate else { return }
            
            let location = Location(ownerUid: userUid, name: self.name, description: self.description, address: corectAddress, timestamp: Timestamp(), latitude: coordinate.latitude, longitude: coordinate.longitude, activityId: activityId ?? "")
            
            try await uploadLocation(location)
            
        } catch {
            isError = true
            messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
