//
//  CreateReplyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 08/05/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics

class CreateReplyViewModel: ObservableObject {
    
    @Published var isError = false
    @Published var messageError: String?
    
    var text: String
    
    private let colloquyService: ColloquyServiceProtocol
    private let increment: ColloquyInteractionCounterServiceProtocol
    
    init(text: String = "", colloquyService: ColloquyServiceProtocol, increment: ColloquyInteractionCounterServiceProtocol) {
        self.text = text
        self.colloquyService = colloquyService
        self.increment = increment
    }
    
    @MainActor
    func saveColloquy(_ colloquyId: String, userId: String?) async {
        
        isError = false
        messageError = nil
        
        do {
            
            guard let userId else { return }
            if self.text.isEmpty { return }
            
            let caption = self.text
            let reply = Colloquy(ownerUid: userId, caption: caption, timestamp: Timestamp(), likes: 0, locationId: nil, ownerColloquy: colloquyId, isDelete: false)
            
            self.text = ""
            
            try await colloquyService.uploadeColloquy(reply)
            try await increment.incrementRepliesCount(colloquyId: colloquyId)
            
        } catch {
            isError = true
            messageError = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
    }
}
