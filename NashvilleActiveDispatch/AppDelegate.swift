//
//  AppDelegate.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import FirebaseCore
import PostHog
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let config = PostHogConfig(projectToken: Secrets.postHogProjectToken, host: Secrets.postHogHost)
        config.captureApplicationLifecycleEvents = true
        PostHogSDK.shared.setup(config)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}
