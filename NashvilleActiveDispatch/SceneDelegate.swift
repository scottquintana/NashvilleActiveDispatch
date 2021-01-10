//
//  SceneDelegate.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        navController = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        configureNavigationBar()
    }

    private func configureNavigationBar() {

        if let navBar = navController?.navigationBar {
            
            navBar.prefersLargeTitles = true
//            navBar.isTranslucent = true
//            navBar.isOpaque = true
            navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        }
    }
}

