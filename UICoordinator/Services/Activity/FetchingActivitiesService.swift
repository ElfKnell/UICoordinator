//
//  FetchingActivitiesService.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 12/05/2025.
//

import Firebase
import Foundation

actor FetchingActivitiesService: FetchingActivitiesProtocol {
    
    private var lastDocument: DocumentSnapshot?
    private var isDataLoaded = false
    private var lastDocumentByUser: DocumentSnapshot?
    private var isDataLoadedByUser = false
    
    func fetchActivities(users: [User], pageSize: Int) async throws -> [Activity] {
        
        if users.isEmpty { return [] }
        if isDataLoaded { return [] }
        let usersId = users.map({ $0.id })
        
        var query = Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", in: usersId)
            .whereField("isDelete", isNotEqualTo: true)
            .order(by: "time", descending: true)
            .limit(to: pageSize)
        
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isDataLoaded = true
            return []
        }
        
        self.lastDocument = snapshot.documents.last
        
        var activitys = snapshot.documents.compactMap { doc -> Activity? in
            var activity = try? doc.data(as: Activity.self)
            if activity?.activityId == nil {
                activity?.activityId = doc.documentID
            }
            return activity
        }
        
        for i in 0 ..< activitys.count
        {
            let ownerUser = users.first(where: { $0.id == activitys[i].ownerUid })
            activitys[i].user = ownerUser
        }
        
        return activitys
        
    }
    
    func fetchActivitiesByUser(user: User, pageSize: Int) async throws -> [Activity] {
        
        if isDataLoadedByUser { return [] }
        
        var query = Firestore
            .firestore()
            .collection("Activity")
            .whereField("ownerUid", isEqualTo: user.id)
            .whereField("isDelete", isNotEqualTo: true)
            .order(by: "time", descending: true)
            .limit(to: pageSize)
        
        if let lastDoc = lastDocumentByUser {
            query = query.start(afterDocument: lastDoc)
        }
        
        let snapshot = try await query.getDocuments()
        
        if snapshot.documents.isEmpty {
            isDataLoadedByUser = true
            return []
        }
        
        self.lastDocumentByUser = snapshot.documents.last
        
        var activities = snapshot.documents.compactMap { doc -> Activity? in
            var activity = try? doc.data(as: Activity.self)
            if activity?.activityId == nil {
                activity?.activityId = doc.documentID
            }
            return activity
        }
        
        for i in 0 ..< activities.count
        {
            activities[i].user = user
        }
        
        return activities
        
    }
    
    func clean() async {
        self.lastDocument = nil
        self.isDataLoaded = false
        self.lastDocumentByUser = nil
        self.isDataLoadedByUser = false
    }
}
