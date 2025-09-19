//
//  EditProfileViewModelBuilder.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

struct EditProfileViewModelBuilder {
    
    static func make() -> EditProfileViewModel {
        
        let firestoreAdapter = FirestoreAdapter()
        let imageUploader = ImageUploader(storage: Storage.storage())
        let logger = SpyLogger()
        
        let userServiceUpdate = UserServiceUpdate(
            firestore: firestoreAdapter,
            imageUpload: imageUploader,
            logger: logger
        )
        
        let generalDeleteService = FirestoreGeneralDeleteService(
            db: firestoreAdapter
        )
        
        let repliesFetchingService = FetchRepliesFirebase(
            fetchLocation: FetchLocationFromFirebase(),
            userService: UserService()
        )
        
        let activityDelete = ActivityDelete(
            serviceDelete: generalDeleteService,
            locationDelete: DeleteLocation(),
            likesDelete: LikesDeleteService(),
            spreadDelete: DeleteSpreadService(
                serviceDelete: generalDeleteService),
            photoService: PhotoService(),
            routesServise: RouteDeleteService(
                servіceDelete: generalDeleteService,
                fetchingRoutes: FetchingRoutesService()),
                colloquyService: ColloquyService(
                    serviceDetete: generalDeleteService,
                    repliesFetchingService: repliesFetchingService,
                    deleteLikes: LikesDeleteService())
        )
            
        let deleteUser = DeleteCurrentUser(
            authDelete: AuthDeleteUser(),
            servіceDelete: generalDeleteService,
            imageUploader: imageUploader,
            activityDelete: activityDelete,
            followsDelete: FollowsDeleteByUser(),
            documentsDocuments: FirestoreDeleteDocuments(),
            deleteLikes: LikesDeleteService(),
            deletePhoto: PhotoService(),
            deleteBlock: BlocksDeleteService()
        )
        
        return EditProfileViewModel(
            userServiseUpdate: userServiceUpdate,
            deleteUser: deleteUser
        )
    }
    
}
