//
//  DocumentSnapshotAdapter.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/06/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DocumentSnapshotAdapter: DocumentSnapshotProtocol {
    
    private let snapshot: FirebaseFirestore.DocumentSnapshot
    
    init(snapshot: FirebaseFirestore.DocumentSnapshot) {
        self.snapshot = snapshot
    }
    
    var documentID: String {
        snapshot.documentID
    }
    
    var exists: Bool {
        snapshot.exists
    }
    
    func data() -> [String : Any]? {
        return snapshot.data()
    }
    
    func decodeData<T: Decodable>(as type: T.Type) throws -> T {
        return try snapshot.data(as: type)
    }
    
}
