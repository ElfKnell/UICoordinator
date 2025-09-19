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
    
    @Published var nickname = ""
    @Published var bio = ""
    @Published var link = ""
    @Published var newPassword = ""
    @Published var isPrivateProfile = false
    @Published var isLoading = false
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
    private let deleteUser: DeleteCurrentUserProtocol
    
    init(userServiseUpdate: UserServiceUpdateProtocol,
         deleteUser: DeleteCurrentUserProtocol) {
        
        self.userServiseUpdate = userServiseUpdate
        self.deleteUser = deleteUser
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
        isLoading = true
        
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
        isLoading = false
    }
    
    @MainActor
    func deleteCurrentUser(user: User?, userSession: FirebaseUserProtocol?) async {
        
        errorMessage = nil
        isError = false
        isLoading = true
        
        do {
            try await deleteUser.deleteUser(currentUser: user, userSession: userSession)
        } catch {
            errorMessage = error.localizedDescription
            isError = true
            Crashlytics.crashlytics().record(error: error)
        }
        isLoading = false
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
