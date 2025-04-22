//
//  DocumentSnapshotProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 19/04/2025.
//

import Foundation

protocol DocumentSnapshotProtocol {
    func decodeData<T: Decodable>(as type: T.Type) throws -> T
}
