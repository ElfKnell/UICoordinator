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
    @Published var isDelete = false
    private var uiImage: UIImage?
    private var userServiseUpdate = UserServiceUpdate()
    
    func updateUserData(user: User, nickname: String, bio: String, link: String, isPrivateProfile: Bool) async {
        if user.isPrivateProfile != isPrivateProfile && (isPrivateProfile || user.isPrivateProfile != nil) {
            await userServiseUpdate.updateUserPrivate(isPrivateProfile: isPrivateProfile, userId: user.id)
        }
        await userServiseUpdate.updateUserProfile(userId: user.id, nickname: nickname,  bio: bio, link: link)
        await uploadeProfileImage(userId: user.id)
        
    }
    
    func deleteCurrentUser(userId: String?) async {
        await userServiseUpdate.deleteUser(userId: userId)
    }
    
    @MainActor
    private func loadPhoto() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func uploadeProfileImage(userId: String) async {
        guard let image = self.uiImage else { return }
        guard let imageURL = await ImageUploader.uploadeImage(image) else { return }
        
        await userServiseUpdate.updateUserProfileImage(withImageURL: imageURL, userId: userId)
    }
    
}
