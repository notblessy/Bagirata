//
//  BagirataApp.swift
//  Bagirata
//
//  Created by Frederich Blessy on 26/06/24.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }
}

@main
struct BagirataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: Bank.self, Friend.self, Split.self, Splitted.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color(hex: "4A93CF"))
        }
        .modelContainer(modelContainer)
    }
}
