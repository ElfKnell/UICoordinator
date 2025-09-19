//
//  DeleteCurrentUser.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/09/2025.
//

import Foundation
import FirebaseCrashlytics

class DeleteCurrentUser: DeleteCurrentUserProtocol {
    
    private let authDelete: AuthDeleteUserProtocol
    private let servіceDelete: FirestoreGeneralDeleteProtocol
    private let imageUploader: ImageUploaderProtocol
    private let activityDelete: ActivityDeleteProtocol
    private let followsDelete: FollowsDeleteByUserProtocol
    private let documentsDocuments: FirestoreDeleteDocumentsProtocol
    private let deleteLikes: LikesDeleteServiceProtocol
    private let deletePhoto: PhotoServiceProtocol
    private let deleteBlock: BlocksDeleteServiceProtocol
    
    init(
        authDelete: AuthDeleteUserProtocol,
        servіceDelete: FirestoreGeneralDeleteProtocol,
        imageUploader: ImageUploaderProtocol,
        activityDelete: ActivityDeleteProtocol,
        followsDelete: FollowsDeleteByUserProtocol,
        documentsDocuments: FirestoreDeleteDocumentsProtocol,
        deleteLikes: LikesDeleteServiceProtocol,
        deletePhoto: PhotoServiceProtocol,
        deleteBlock: BlocksDeleteServiceProtocol
    ) {
            
        self.authDelete = authDelete
        self.servіceDelete = servіceDelete
        self.imageUploader = imageUploader
        self.activityDelete = activityDelete
        self.followsDelete = followsDelete
        self.documentsDocuments = documentsDocuments
        self.deleteLikes = deleteLikes
        self.deletePhoto = deletePhoto
        self.deleteBlock = deleteBlock

    }
    
    func deleteUser(currentUser: User?, userSession: FirebaseUserProtocol?) async throws {
        
        guard let user = userSession, let currentUser else {
            throw UserError.userNotFound
        }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask {
                
                do {
                    try await self.followsDelete.deleteFollowsByUser(userId: currentUser.id)
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.deleteBlock.deleteBlocksByUser(userId: currentUser.id)
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.documentsDocuments.deleteDocumentsWithDependencies(
                        collectionName: CollectionNameForLike.activityLikes.value,
                        userId: currentUser.id
                    )
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.documentsDocuments.deleteDocumentsWithDependencies(
                        collectionName: CollectionNameForLike.likes.value,
                        userId: currentUser.id
                    )
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.documentsDocuments.deleteDocumentsWithDependencies(
                        collectionName: "locations",
                        userId: currentUser.id
                    ) { locationId in
                        try await self.deletePhoto.deletePhotoByLocation(locationId)
                    }
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.documentsDocuments.deleteDocumentsWithDependencies(
                        collectionName: "colloquies",
                        userId: currentUser.id
                    ) { colloquyId in
                        try await self.deleteLikes.likesDelete(
                            objectId: colloquyId,
                            collectionName: .likes
                        )
                    }
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            group.addTask {
                
                do {
                    try await self.activityDelete.deleteAllActivitiesByUser(userId: currentUser.id)
                } catch {
                    Crashlytics.crashlytics().record(error: error)
                }
                
            }
            
            try await group.waitForAll()
        }
        
        try await servіceDelete.deleteDocument(from: "unique_usernames", documentId: currentUser.username)
        try await servіceDelete.deleteDocument(from: "users", documentId: currentUser.id)
        
        try await authDelete.deleteCurrentUser(userSession: user)
        
    }
    
}
