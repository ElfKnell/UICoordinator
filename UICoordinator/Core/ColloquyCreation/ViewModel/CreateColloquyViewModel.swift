//
//  CreateColloquyViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 28/02/2024.
//

import Firebase
import FirebaseCrashlytics

class CreateColloquyViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var isError = false
    @Published var isLoading = false
    
    private let likeCount: ColloquyInteractionCounterServiceProtocol
    private let colloquyService: ColloquyServiceProtocol
    private let contentModerator: ContentModeratorProtocol
    
    init(likeCount: ColloquyInteractionCounterServiceProtocol,
         colloquyService: ColloquyServiceProtocol,
         contentModerator: ContentModeratorProtocol) {
        
        self.likeCount = likeCount
        self.colloquyService = colloquyService
        self.contentModerator = contentModerator
    }
    
    @MainActor
    func uploadColloquy(userId: String?, caption: String, locatioId: String?) async {
        
        self.isLoading = true
        self.isError = false
        self.errorMessage = nil
        
        do {

            guard let uid = userId else {
                throw UserError.userNotFound
            }
            
            guard !caption.isEmpty else {
                throw ColloquyError.captionIsEmpty
            }
            
            let analyze = try await contentModerator.moderateText(text: caption)
            
            guard !analyze else {
                throw ModerationError.invalidPost
            }

            let colloquy = Colloquy(ownerUid: uid, caption: caption, timestamp: Timestamp(), likes: 0, locationId: locatioId, ownerColloquy: "", isDelete: false)
            
            try await colloquyService.uploadeColloquy(colloquy)
            
        } catch {
            self.isError = true
            self.errorMessage = error.localizedDescription
            Crashlytics.crashlytics().record(error: error)
        }
        
        self.isLoading = false
    }
}
