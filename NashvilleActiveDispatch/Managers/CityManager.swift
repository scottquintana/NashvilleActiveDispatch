//
//  CityManager.swift
//  Active Dispatch
//

import UIKit

final class CityManager {

    static let shared = CityManager()

    private let userDefaultsKey = "selectedCity"

    private init() {}

    // nil means the user hasn't chosen a city yet (show CitySelectionViewController)
    var selectedCity: City? {
        get {
            guard let raw = UserDefaults.standard.string(forKey: userDefaultsKey) else { return nil }
            return City(rawValue: raw)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: userDefaultsKey)
        }
    }

    // Always returns a valid theme, defaulting to Nashville before any city is chosen.
    var currentTheme: CityTheme {
        selectedCity?.theme ?? City.nashville.theme
    }

}
