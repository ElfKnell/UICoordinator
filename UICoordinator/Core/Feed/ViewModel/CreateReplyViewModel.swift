//
//  CreateReplyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import Observation
import Foundation
import Firebase

@Observable
class CreateReplyViewModel {
    
    var text: String = ""
    
    private let colloquyService = ColloquyService(serviceDetete: FirestoreGeneralDeleteService(), repliesFetchingService: FetchRepliesFirebase())
    private let increment = ColloquyInteractionCounterService()
    
    func saveColloquy(_ colloquyId: String, userId: String?) async {
        
        guard let userId else { return }
        
        let caption = self.text
        let reply = Colloquy(ownerUid: userId, caption: caption, timestamp: Timestamp(), likes: 0, locationId: nil, ownerColloquy: colloquyId, isDelete: false)
        
        self.text = ""
        
        await colloquyService.uploadeColloquy(reply)
        await increment.incrementRepliesCount(colloquyId: colloquyId)
    }
}
