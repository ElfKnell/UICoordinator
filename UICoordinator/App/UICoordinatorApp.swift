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
    @StateObject var locatonFetcher = LocationFetcher()
    @StateObject var currentUserViewModel = CurrentUserProfileViewModel()
    
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    locatonFetcher.start()
                }
                .environmentObject(locatonFetcher)
                .environmentObject(currentUserViewModel)
        }
    }
}
