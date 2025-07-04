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
    @Published var isError = false
    @Published var errorMessage: String?
    
    private var uiImage: UIImage?
    private let userServiseUpdate: UserServiceUpdateProtocol
    
    init(userServiseUpdate: UserServiceUpdateProtocol) {
        
        self.userServiseUpdate = userServiseUpdate
    }
    
    @MainActor
    func updateUserData(user: User,
                        nickname: String,
                        bio: String,
                        link: String,
                        isPrivateProfile: Bool) async {
        
        var userData: [String: Any]  = [:]
        errorMessage = nil
        isError = true
        
        let trimmedBio = bio.trimmingCharacters(in: .whitespaces)
        let trimmedLink = link.trimmingCharacters(in: .whitespaces)
        let trimmedUsername = nickname.trimmingCharacters(in: .whitespaces)
        
        if user.isPrivateProfile != isPrivateProfile {
            userData["isPrivateProfile"] = isPrivateProfile
        }
        
        if trimmedBio != user.bio && !trimmedBio.isEmpty {
            userData["bio"] = trimmedBio
        }
        
        if trimmedLink != user.link && !trimmedLink.isEmpty {
            userData["link"] = trimmedLink
        }
        
        if trimmedUsername != user.username && !trimmedUsername.isEmpty {
            userData["username"] = trimmedUsername
        }
        
        do {
            try await userServiseUpdate.updateUserProfile(user: user,
                                                      image: uiImage,
                                                      dataUser: userData)
        } catch {
            errorMessage = error.localizedDescription
            isError = true
        }
        
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
    
}
