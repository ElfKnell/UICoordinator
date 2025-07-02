//
//  DocumentSnapshotProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation

protocol DocumentSnapshotProtocol {
    
    var documentID: String { get }
    var exists: Bool { get }
    
    func data() -> [String: Any]?
    func decodeData<T: Decodable>(as type: T.Type) throws -> T
}
