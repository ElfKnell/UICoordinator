//
//  EditActivityViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 16/08/2025.
//

import Foundation

class EditActivityViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private let activityServise: ActivityUpdateProtocol
    
    init(activityServise: ActivityUpdateProtocol) {
        self.activityServise = activityServise
    }
    
    func updateActivity(_ activity: Activity) async {
        
        self.errorMessage = nil
        self.showAlert = false
        
        do {
            try await activityServise.updateActivity(activity)
        } catch {
            self.errorMessage = error.localizedDescription
            self.showAlert = true
        }
    }
}
