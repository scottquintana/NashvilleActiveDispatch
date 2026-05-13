//
//  FilterManager.swift
//  Active Dispatch
//

import Foundation
import FirebaseRemoteConfig

final class FilterManager {

    static let shared = FilterManager()

    private let remoteConfig = RemoteConfig.remoteConfig()
    private let showAllKey = "showAllIncidentTypes"

    // Whether the user has opted in to see unfiltered results.
    var showAllIncidentTypes: Bool {
        get { UserDefaults.standard.bool(forKey: showAllKey) }
        set { UserDefaults.standard.set(newValue, forKey: showAllKey) }
    }

    private init() {
        configureDefaults()
        fetch()
    }

    // MARK: - Setup

    private func configureDefaults() {
        let settings = RemoteConfigSettings()
        // In production, 1 hour is a reasonable fetch interval.
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings

        // Fallback filter list used if Remote Config has never been fetched.
        remoteConfig.setDefaults([
            "incident_filters": defaultFiltersJSON() as NSObject
        ])
    }

    private func fetch() {
        remoteConfig.fetchAndActivate { _, error in
            if let error = error {
                print("Remote Config fetch failed: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Filtering

    /// Returns `true` if the incident should be hidden from the feed.
    func shouldFilter(_ incidentTypeName: String, for city: City) -> Bool {
        guard !showAllIncidentTypes else { return false }

        let blockedList = blockedTypes(for: city)
        let normalized = incidentTypeName.uppercased().trimmingCharacters(in: .whitespaces)
        return blockedList.contains(normalized)
    }

    /// Applies the filter to a list of view models.
    func apply(to viewModels: [IncidentViewModel], city: City) -> [IncidentViewModel] {
        guard !showAllIncidentTypes else { return viewModels }

        let blockedList = blockedTypes(for: city)
        guard !blockedList.isEmpty else { return viewModels }

        return viewModels.filter { vm in
            let normalized = vm.incidentDescription.uppercased().trimmingCharacters(in: .whitespaces)
            return !blockedList.contains(normalized)
        }
    }

    // MARK: - Helpers

    private func blockedTypes(for city: City) -> Set<String> {
        let jsonString = remoteConfig["incident_filters"].stringValue
        guard
            let data = jsonString.data(using: .utf8),
            let dict = try? JSONDecoder().decode([String: [String]].self, from: data),
            let list = dict[city.apiSlug]
        else {
            return []
        }
        return Set(list.map { $0.uppercased() })
    }

    // MARK: - Default filter list (in-app fallback)

    private func defaultFiltersJSON() -> String {
        """
        {
          "sf": [
            "TRAF VIOLATION TOW",
            "TRAF VIOLATION CITE",
            "TOW TRUCK",
            "SIT/LIE ENFORCEMENT",
            "MEET W/CITIZEN",
            "MEET W/CITY EMPLOYEE",
            "CITIZEN STANDBY",
            "PRISONER TRANSPORT",
            "ARREST MADE",
            "CITIZEN ARREST"
          ],
          "nashville": [],
          "pdx": []
        }
        """
    }
}
