//
//  EditProfileViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/02/2024.
//

import SwiftUI
import PhotosUI

class EditProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadPhoto() } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    func updateUserData() async throws {
        try await uploadeProfileImage()
    }
    
    @MainActor
    private func loadPhoto() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func uploadeProfileImage() async throws {
        guard let image = self.uiImage else { return }
        guard let imageURL = try? await ImageUploader.uploadeImage(image) else { return }
        
        try await UserService.shared.updateUserProfileImage(withImageURL: imageURL)
    }
}
