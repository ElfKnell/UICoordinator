//
//  UICoordinatorApp.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct UICoordinatorApp: App {
    @StateObject var currentUserViewModel = CurrentUserProfileViewModel()
    @StateObject var userFollowers = UserFollowers()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            UICoordinatorRootView()
                .environmentObject(currentUserViewModel)
                .environmentObject(userFollowers)
        }
    }
}
