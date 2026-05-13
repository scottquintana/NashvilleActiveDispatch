//
//  SceneDelegate.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        if let savedCity = CityManager.shared.selectedCity {
            showMainApp(city: savedCity)
        } else {
            showCitySelection()
        }

        window?.makeKeyAndVisible()
    }

    // MARK: - Navigation

    func showMainApp(city: City) {
        let viewController = ViewController(city: city)
        let navController = UINavigationController(rootViewController: viewController)
        configureNavigationBar(navController.navigationBar)
        window?.rootViewController = navController
    }

    func showCitySelection() {
        let citySelectionVC = CitySelectionViewController()
        citySelectionVC.onCitySelected = { [weak self] city in
            self?.showMainApp(city: city)
        }
        window?.rootViewController = citySelectionVC
    }

    // Called from SettingsViewController when the user switches city mid-session.
    // CitySelectionViewController dismisses itself before firing the callback,
    // so the modal is already gone by the time this runs.
    func switchToCity(_ city: City) {
        showMainApp(city: city)
    }

    // MARK: - Nav bar appearance

    private func configureNavigationBar(_ navBar: UINavigationBar) {
        navBar.prefersLargeTitles = true
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
