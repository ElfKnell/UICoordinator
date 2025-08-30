//
//  UICoordinatorApp.swift
//  UICoordinator
//
//  Created by Andrii Kyrychenko on 17/02/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import FirebaseCrashlytics

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
      FirebaseApp.configure()
      
      Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)

    return true
  }
}

@main
struct UICoordinatorApp: App {
    
    @StateObject private var container = DIContainer()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            UICoordinatorRootView()
                .environmentObject(container)
                .onAppear {
                    container.networkMonitor.startMonitoringForOffline()
                }
                .onDisappear {
                    container.networkMonitor.stopMonitoringForOffline()
                }
        }
    }
}
