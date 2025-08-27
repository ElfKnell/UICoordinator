//
//  ActivityCellFactory.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 18/06/2025.
//

import Foundation
import SwiftUI

struct ActivityCellFactory {
    
    static func make(activity: Activity,
                     isDelete: Binding<Bool>,
                     isUpdate: Binding<Bool>) -> ActivityCell {
        
        let viewModel = ActivityCellViewModel(
            spreadActivity: ActivitySpreading(userServise: UserService(),
                                              fetchingActivity: FetchingActivityService()),
            activityUpdate: ActivityServiceUpdate(),
            deleteActivity: ActivityDelete(
                servaceDelete: FirestoreGeneralDeleteService(
                    db: FirestoreAdapter()),
                locationDelete: DeleteLocation(),
                likesDelete: LikesDeleteService(
                    likeServise: LikeService(
                        serviceCreate: FirestoreLikeCreateServise(),
                        serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter()))),
                spreadDelete: DeleteSpreadService(
                    serviceDelete: FirestoreGeneralDeleteService(db: FirestoreAdapter())),
                photoService: PhotoService(),
                videoService: VideoService(),
                routesServise: RouteDeleteService(
                    servіceDelete: FirestoreGeneralDeleteService(
                        db: FirestoreAdapter()),
                    fetchingRoutes: FetchingRoutesService()))
        )
        
        let viewModelLike = LikesViewModel(
            collectionName: .activityLikes,
            likeCount: ColloquyInteractionCounterService(),
            likeService: LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                     serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter())),
            fethingLike: FetchLikesService(likeRepository: FirestoreLikeRepository()),
            activityUpdate: ActivityServiceUpdate()
        )
        
        return ActivityCell(activity: activity,
                            isDelete: isDelete,
                            isUpdate: isUpdate,
                            viewModel: viewModel,
                            viewModelLike: viewModelLike)
    }
}
