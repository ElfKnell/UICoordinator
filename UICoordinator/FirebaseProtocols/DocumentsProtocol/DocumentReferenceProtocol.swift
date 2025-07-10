//
//  DocumentReferenceProtocol.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/07/2025.
//

import Foundation
import Firebase

protocol DocumentReferenceProtocol {
    
    var documentId: String { get }
    func updateData(_ fields: [AnyHashable : Any]) async throws
    func delete() async throws
    
}
