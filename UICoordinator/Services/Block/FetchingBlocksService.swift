//
//  FetchingBlokcs.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/09/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics
import Observation

@Observable
class FetchingBlocksService: FetchingBlocksServiceProtocol {
    
    var blocksId: Set<String> = []
    var blockedsId: Set<String> = []
    
    @MainActor
    func fetchBlockers(_ currentUser: User?) async {
        
        do {
            
            guard let userId = currentUser?.id else {
                throw UserError.userNotFound
            }
            
            async let snapshotBlocked = try await Firestore.firestore()
                .collection("block")
                .whereField("blocked", isEqualTo: userId)
                .getDocuments()
            
            async let snapshotBlocker = try await Firestore.firestore()
                .collection("block")
                .whereField("blocker", isEqualTo: userId)
                .getDocuments()
            
            let (blockedResult, blockerResult) = try await (snapshotBlocked, snapshotBlocker)
            
            let blockedS = blockedResult.documents.compactMap { try? $0.data(as: Block.self) }
            let blockerS = blockerResult.documents.compactMap { try? $0.data(as: Block.self) }
            
            let blockersId = Set(blockedS.map { $0.blocker })
            let blockedsId = Set(blockerS.map { $0.blocked })
            
            self.blockedsId = blockedsId
            
            self.blocksId = blockedsId.union(blockersId)
            
        } catch {
            
            Crashlytics.crashlytics()
                .setCustomValue(currentUser?.id ?? "none", forKey: "current_user_id")
            Crashlytics.crashlytics().record(error: error)
            
        }
    }
    
}
