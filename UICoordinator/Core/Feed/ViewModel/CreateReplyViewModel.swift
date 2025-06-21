//
//  CreateReplyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import Foundation
import Firebase

class CreateReplyViewModel: ObservableObject {
    
    var text: String
    
    private let colloquyService: ColloquyServiceProtocol
    private let increment: ColloquyInteractionCounterServiceProtocol
    
    init(text: String = "", colloquyService: ColloquyServiceProtocol, increment: ColloquyInteractionCounterServiceProtocol) {
        self.text = text
        self.colloquyService = colloquyService
        self.increment = increment
    }
    
    func saveColloquy(_ colloquyId: String, userId: String?) async {
        
        guard let userId else { return }
        if self.text.isEmpty { return }
        
        let caption = self.text
        let reply = Colloquy(ownerUid: userId, caption: caption, timestamp: Timestamp(), likes: 0, locationId: nil, ownerColloquy: colloquyId, isDelete: false)
        
        self.text = ""
        
        await colloquyService.uploadeColloquy(reply)
        await increment.incrementRepliesCount(colloquyId: colloquyId)
    }
}
