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
    private let maxAgeKey = "maxAgeHours"

    static let maxAgeUnlimited = 12

    // Whether the user has opted in to see unfiltered results.
    var showAllIncidentTypes: Bool {
        get { UserDefaults.standard.bool(forKey: showAllKey) }
        set { UserDefaults.standard.set(newValue, forKey: showAllKey) }
    }

    static let timeWindowChanged = Notification.Name("FilterManager.timeWindowChanged")

    // Maximum age of incidents to show, in hours. 12 = no age filter.
    var maxAgeHours: Int {
        get {
            let v = UserDefaults.standard.integer(forKey: maxAgeKey)
            return v == 0 ? FilterManager.maxAgeUnlimited : v
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxAgeKey)
            NotificationCenter.default.post(name: FilterManager.timeWindowChanged, object: nil)
        }
    }

    var recencyLabel: String {
        maxAgeHours >= FilterManager.maxAgeUnlimited
            ? "All incidents (12+ hours)"
            : "Last \(maxAgeHours) hour\(maxAgeHours == 1 ? "" : "s")"
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

    /// Applies all active filters to a list of view models.
    func apply(to viewModels: [IncidentViewModel], city: City) -> [IncidentViewModel] {
        var result = viewModels

        // Type filter
        if !showAllIncidentTypes {
            let blockedList = blockedTypes(for: city)
            if !blockedList.isEmpty {
                result = result.filter { vm in
                    let normalized = vm.incidentDescription.uppercased().trimmingCharacters(in: .whitespaces)
                    return !blockedList.contains(normalized)
                }
            }
        }

        // Age filter
        if maxAgeHours < FilterManager.maxAgeUnlimited {
            let cutoff = Date().addingTimeInterval(-Double(maxAgeHours) * 3600)
            result = result.filter { vm in
                let date = DateHelper.convertISO8601ToDate(vm.alertData.callTimeReceived)
                return date >= cutoff
            }
        }

        return result
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
