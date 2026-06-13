//
//  AnalyticsManager.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/28/26.
//

import Foundation
import PostHog
import Network
import CoreLocation

final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {
        startReachability()
    }

    // MARK: - Event Names
    private enum EventName {
        static let incidentTapped = "incident_tapped"

        static let mapOpened = "map_opened"

        static let refreshTriggered = "refresh_triggered"
        static let refreshSucceeded = "refresh_succeeded"
        static let refreshFailed = "refresh_failed"

        static let sortChanged = "sort_changed"

        static let alertsFetchFailed = "alerts_fetch_failed"
        static let alertsFetchEmpty = "alerts_fetch_empty"
        static let cityFeedEmpty = "city_feed_empty"

        static let locationPermissionDenied = "location_permission_denied"
        static let locationPermissionRestricted = "location_permission_restricted"
        static let locationServicesDisabled = "location_services_disabled"
        static let locationAccuracy = "location_accuracy"

        static let cityChanged = "city_changed"
        static let citySelected = "city_selected"

        static let filterToggled = "filter_toggled"
        static let timeWindowChanged = "time_window_changed"

        static let mapAnnotationTapped = "map_annotation_tapped"
        static let mapNavigated = "map_navigated"

        static let settingsOpened = "settings_opened"
        static let incidentsLoaded = "incidents_loaded"

        static let error = "error_occurred"
    }

    // MARK: - Parameter Keys
    private enum ParameterKey {
        static let incidentType = "incident_type"
        static let neighborhood = "neighborhood"
        static let distanceMiles = "distance_miles"

        static let mapSource = "map_source"                 // "button" | "tap"
        static let sortDimension = "sort_dimension"         // "time" | "distance"
        static let sortDirection = "sort_direction"         // "asc" | "desc"

        static let endpoint = "endpoint"                    // "get_alerts"
        static let httpStatus = "http_status"               // Int
        static let isOffline = "is_offline"                 // Bool-ish (0/1)
        static let errorDomain = "error_domain"
        static let errorCode = "error_code"

        static let errorType = "error_type"
        static let errorMessage = "error_message"
        static let errorContext = "error_context"

        static let locationAccuracyM = "location_accuracy_m"
        static let accuracyBad = "accuracy_bad"             // 0/1
        static let accuracyExtreme = "accuracy_extreme"     // 0/1

        static let showAll = "show_all"
        static let hours = "hours"
        static let direction = "direction"
        static let count = "count"

        static let city = "city"
    }

    // MARK: - City

    private var citySlug: String {
        CityManager.shared.selectedCity?.apiSlug ?? "unknown"
    }

    // MARK: - Reachability (is_offline)

    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "AnalyticsManager.NWPathMonitor")
    private var isOfflineFlag: Bool = false
    private let offlineLock = NSLock()

    private func startReachability() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let offline = (path.status != .satisfied)
            self.offlineLock.lock()
            self.isOfflineFlag = offline
            self.offlineLock.unlock()
        }
        monitor.start(queue: monitorQueue)
    }

    private func isOffline() -> Bool {
        offlineLock.lock()
        defer { offlineLock.unlock() }
        return isOfflineFlag
    }

    // MARK: - Helpers

    private func baseNetworkParams(endpoint: String, httpStatus: Int? = nil, error: Error? = nil) -> [String: Any] {
        var params: [String: Any] = [
            ParameterKey.endpoint: endpoint,
            ParameterKey.isOffline: isOffline() ? 1 : 0,
            ParameterKey.city: citySlug
        ]

        if let httpStatus {
            params[ParameterKey.httpStatus] = httpStatus
        }

        if let nsError = error as NSError? {
            params[ParameterKey.errorDomain] = nsError.domain
            params[ParameterKey.errorCode] = nsError.code
        }

        return params
    }

    // MARK: - Existing events

    func logIncidentTapped(incidentType: String, neighborhood: String, distanceMiles: Double) {
        PostHogSDK.shared.capture(EventName.incidentTapped, properties: [
            ParameterKey.incidentType: incidentType,
            ParameterKey.neighborhood: neighborhood,
            ParameterKey.distanceMiles: distanceMiles,
            ParameterKey.city: citySlug
        ])
    }

    func logLocationPermissionDenied() {
        PostHogSDK.shared.capture(EventName.locationPermissionDenied, properties: [ParameterKey.city: citySlug])
    }

    func logLocationPermissionRestricted() {
        PostHogSDK.shared.capture(EventName.locationPermissionRestricted, properties: [ParameterKey.city: citySlug])
    }

    func logLocationServicesDisabled() {
        PostHogSDK.shared.capture(EventName.locationServicesDisabled, properties: [ParameterKey.city: citySlug])
    }

    func logError(type: String, message: String, context: String? = nil, extra: [String: Any]? = nil) {
        var properties: [String: Any] = [
            ParameterKey.errorType: type,
            ParameterKey.errorMessage: message,
            ParameterKey.city: citySlug
        ]

        if let context {
            properties[ParameterKey.errorContext] = context
        }
        if let extra {
            for (k, v) in extra { properties[k] = v }
        }

        PostHogSDK.shared.capture(EventName.error, properties: properties)
    }

    func logError(_ error: ADError, context: String? = nil, extra: [String: Any]? = nil) {
        logError(type: "ADError", message: error.rawValue, context: context, extra: extra)
    }

    // MARK: - New events you requested

    func logMapOpened(source: MapOpenSource) {
        PostHogSDK.shared.capture(EventName.mapOpened, properties: [
            ParameterKey.mapSource: source.rawValue,
            ParameterKey.city: citySlug
        ])
    }

    enum MapOpenSource: String {
        case button
        case tap
    }

    func logRefreshTriggered(endpoint: String, source: String = "pull") {
        var params = baseNetworkParams(endpoint: endpoint)
        params["source"] = source
        PostHogSDK.shared.capture(EventName.refreshTriggered, properties: params)
    }

    func logRefreshSucceeded(endpoint: String, httpStatus: Int? = nil) {
        PostHogSDK.shared.capture(EventName.refreshSucceeded, properties: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus))
    }

    func logRefreshFailed(endpoint: String, httpStatus: Int? = nil, error: Error? = nil) {
        PostHogSDK.shared.capture(EventName.refreshFailed, properties: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus, error: error))
    }

    func logSortChanged(option: SortOption) {
        let (dimension, direction) = sortMetadata(option)
        PostHogSDK.shared.capture(EventName.sortChanged, properties: [
            ParameterKey.sortDimension: dimension,
            ParameterKey.sortDirection: direction,
            ParameterKey.city: citySlug
        ])
    }

    private func sortMetadata(_ option: SortOption) -> (dimension: String, direction: String) {
        switch option {
        case .timeNewest: return ("time", "desc")
        case .timeOldest: return ("time", "asc")
        case .distanceNearest: return ("distance", "asc")
        case .distanceFarthest: return ("distance", "desc")
        }
    }

    func logAlertsFetchFailed(endpoint: String, httpStatus: Int? = nil, error: Error? = nil) {
        PostHogSDK.shared.capture(EventName.alertsFetchFailed, properties: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus, error: error))
    }

    func logAlertsFetchEmpty(endpoint: String, httpStatus: Int? = nil) {
        PostHogSDK.shared.capture(EventName.alertsFetchEmpty, properties: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus))
    }

    func logCityFeedEmpty() {
        PostHogSDK.shared.capture(EventName.cityFeedEmpty, properties: [ParameterKey.city: citySlug])
    }

    func logLocationAccuracy(
        _ location: CLLocation,
        badThresholdMeters: CLLocationAccuracy = 10_000,
        extremeThresholdMeters: CLLocationAccuracy = 50_000
    ) {
        let accuracy = location.horizontalAccuracy
        guard accuracy >= 0 else { return }

        let isBad = accuracy >= badThresholdMeters
        let isExtreme = accuracy >= extremeThresholdMeters

        PostHogSDK.shared.capture(EventName.locationAccuracy, properties: [
            ParameterKey.locationAccuracyM: accuracy,
            ParameterKey.accuracyBad: isBad ? 1 : 0,
            ParameterKey.accuracyExtreme: isExtreme ? 1 : 0,
            ParameterKey.city: citySlug
        ])
    }

    // MARK: - City selection

    func logCityChanged(city: City) {
        PostHogSDK.shared.capture(EventName.cityChanged, properties: [ParameterKey.city: city.apiSlug])
    }

    func logCitySelected(city: City) {
        PostHogSDK.shared.capture(EventName.citySelected, properties: [ParameterKey.city: city.apiSlug])
    }

    // MARK: - Settings

    func logFilterToggled(showAll: Bool) {
        PostHogSDK.shared.capture(EventName.filterToggled, properties: [
            ParameterKey.showAll: showAll,
            ParameterKey.city: citySlug
        ])
    }

    func logTimeWindowChanged(hours: Int) {
        PostHogSDK.shared.capture(EventName.timeWindowChanged, properties: [
            ParameterKey.hours: hours,
            ParameterKey.city: citySlug
        ])
    }

    func logSettingsOpened() {
        PostHogSDK.shared.capture(EventName.settingsOpened, properties: [ParameterKey.city: citySlug])
    }

    // MARK: - Map

    func logMapAnnotationTapped(incidentType: String, neighborhood: String) {
        PostHogSDK.shared.capture(EventName.mapAnnotationTapped, properties: [
            ParameterKey.incidentType: incidentType,
            ParameterKey.neighborhood: neighborhood,
            ParameterKey.city: citySlug
        ])
    }

    enum MapNavDirection: String {
        case left, right
    }

    func logMapNavigated(direction: MapNavDirection) {
        PostHogSDK.shared.capture(EventName.mapNavigated, properties: [
            ParameterKey.direction: direction.rawValue,
            ParameterKey.city: citySlug
        ])
    }

    // MARK: - Feed

    func logIncidentsLoaded(count: Int) {
        PostHogSDK.shared.capture(EventName.incidentsLoaded, properties: [
            ParameterKey.count: count,
            ParameterKey.city: citySlug
        ])
    }
}
