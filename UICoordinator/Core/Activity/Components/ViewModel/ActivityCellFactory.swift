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
                videoService: VideoService()))
        
        let viewModelLike = LikesViewModel(
            collectionName: .activityLikes,
            likeCount: ColloquyInteractionCounterService(),
            likeService: LikeService(serviceCreate: FirestoreLikeCreateServise(),
                                     serviceDetete: FirestoreGeneralDeleteService(db: FirestoreAdapter())),
            fethingLike: FetchLikesService(likeRepository: FirestoreLikeRepository()),
            activityUpdate: ActivityServiceUpdate())
        
        return ActivityCell(activity: activity,
                            viewModel: viewModel,
                            viewModelLike: viewModelLike,
                            isDelete: isDelete,
                            isUpdate: isUpdate)
    }
}
