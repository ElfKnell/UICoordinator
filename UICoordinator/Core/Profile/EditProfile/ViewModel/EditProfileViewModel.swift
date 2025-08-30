//
//  EditProfileViewModel.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 26/02/2024.
//

import SwiftUI
import PhotosUI
import FirebaseCrashlytics

class EditProfileViewModel: ObservableObject {
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { await loadPhoto() } }
    }
    @Published var profileImage: Image?
    @Published var isDelete = false
    @Published var isError = false
    @Published var errorMessage: String?
    @Published var eula = "https://elfknell.github.io/Licenses/eula.html"
    @Published var privacyPolicy = "https://elfknell.github.io/Licenses/privacy_policy.html"
    
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
        isError = false
        
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
        
        if trimmedUsername != user.username && isValidUsername(trimmedUsername) {
            userData["username"] = trimmedUsername
        }
        
        do {
            try await userServiseUpdate.updateUserProfile(user: user,
                                                      image: uiImage,
                                                      dataUser: userData)
        } catch let error as UserError {
            errorMessage = error.description
            isError = true
            Crashlytics.crashlytics().record(error: error)
        } catch {
            errorMessage = error.localizedDescription
            isError = true
            Crashlytics.crashlytics().record(error: error)
        }
        
    }
    
    func deleteCurrentUser(userId: String?) async {
        
        errorMessage = nil
        isError = false
        
        do {
            try await userServiseUpdate.deleteUser(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
            isError = true
            Crashlytics.crashlytics().record(error: error)
        }
    }
    
    @MainActor
    private func loadPhoto() async {
        guard let item = selectedItem else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    private func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = #"^[A-Za-z0-9_-]+$"#
        return NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
    }
    
}
