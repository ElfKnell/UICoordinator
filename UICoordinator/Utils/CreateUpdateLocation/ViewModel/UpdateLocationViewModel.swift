//
//  UpdateLocationViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 14/09/2024.
//

import Foundation
import Firebase

class UpdateLocationViewModel: LocationService, ObservableObject {
    
    private let deleteLocation: DeleteLocationProtocol
    private let photoService: PhotoServiceProtocol
    private let videoService: VideoServiceProtocol
    
    @Published var name = ""
    @Published var description = ""
    @Published var address = ""
    
    init(deleteLocation: DeleteLocationProtocol,
         photoService: PhotoServiceProtocol,
         videoService: VideoServiceProtocol) {
        
        self.deleteLocation = deleteLocation
        self.photoService = photoService
        self.videoService = videoService
    }
    
    func initInfo(location: Location?) {
        self.name = location?.name ?? ""
        self.description = location?.description ?? ""
        
        if let address = location?.address {
            self.address = address
        }
    }
    
    func deleteLocation(locationId: String?, activityId: String?) async throws {
        
        do {
            guard let locationId = locationId else { return }
            
            if activityId == nil {
                let fotos = try await photoService.fetchPhotosByLocation(locationId)
                let videos = try await videoService.fetchVideosByLocation(locationId)
                
                for foto in fotos {
                    try await photoService.deletePhoto(photo: foto)
                }
                
                for video in videos {
                    try await videoService.deleteVideo(video: video)
                }
            }

            await deleteLocation.deleteLocation(at: locationId)
            
        } catch {
            print("DEBUGE: error delete - \(error.localizedDescription)")
        }
    }
    
    func saveLocation(_ location: Location?, activityId: String?, user: User?) async throws {
        
        guard let userId = user?.id else { return }
        
        if location?.locationId == nil {
            
            try await createLocation(userId: userId, location: location, activityId: activityId)
            
        } else {
            
            try await updateLocation(locationId: location?.id)
            
        }
    }
    
    private func updateLocation(locationId: String?) async throws {
        
        guard let locationId = locationId else { return }
        if !self.address.isEmpty {
            await updateAddressLocation(address: self.address, locationId: locationId)
        }
        await updateNameAndDescriptionLocation(name: self.name, description: self.description, locationId: locationId)
    }
    
    private func createLocation(userId: String, location: Location?, activityId: String?) async throws {
        guard let location = location else { return }
        let newLocation = Location(ownerUid: userId, name: name, description: description, address: address, timestamp: Timestamp(), latitude: location.latitude, longitude: location.longitude, activityId: activityId ?? "")
        await uploadLocation(newLocation)
    }
    
}
