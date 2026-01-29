//
//  AnalyticsManager.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/28/26.
//

import Foundation
import FirebaseAnalytics
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

        static let locationPermissionDenied = "location_permission_denied"
        static let locationPermissionRestricted = "location_permission_restricted"
        static let locationServicesDisabled = "location_services_disabled"
        static let locationAccuracy = "location_accuracy"

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
            ParameterKey.isOffline: isOffline() ? 1 : 0
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
        Analytics.logEvent(EventName.incidentTapped, parameters: [
            ParameterKey.incidentType: incidentType,
            ParameterKey.neighborhood: neighborhood,
            ParameterKey.distanceMiles: distanceMiles
        ])
    }

    func logLocationPermissionDenied() {
        Analytics.logEvent(EventName.locationPermissionDenied, parameters: nil)
    }

    func logLocationPermissionRestricted() {
        Analytics.logEvent(EventName.locationPermissionRestricted, parameters: nil)
    }

    func logLocationServicesDisabled() {
        Analytics.logEvent(EventName.locationServicesDisabled, parameters: nil)
    }

    func logError(type: String, message: String, context: String? = nil, extra: [String: Any]? = nil) {
        var parameters: [String: Any] = [
            ParameterKey.errorType: type,
            ParameterKey.errorMessage: message
        ]

        if let context {
            parameters[ParameterKey.errorContext] = context
        }
        if let extra {
            for (k, v) in extra { parameters[k] = v }
        }

        Analytics.logEvent(EventName.error, parameters: parameters)
    }

    func logError(_ error: ADError, context: String? = nil, extra: [String: Any]? = nil) {
        logError(type: "ADError", message: error.rawValue, context: context, extra: extra)
    }

    // MARK: - New events you requested

    func logMapOpened(source: MapOpenSource) {
        Analytics.logEvent(EventName.mapOpened, parameters: [
            ParameterKey.mapSource: source.rawValue
        ])
    }

    enum MapOpenSource: String {
        case button
        case tap
    }

    func logRefreshTriggered(endpoint: String) {
        Analytics.logEvent(EventName.refreshTriggered, parameters: baseNetworkParams(endpoint: endpoint))
    }

    func logRefreshSucceeded(endpoint: String, httpStatus: Int? = nil) {
        Analytics.logEvent(EventName.refreshSucceeded, parameters: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus))
    }

    func logRefreshFailed(endpoint: String, httpStatus: Int? = nil, error: Error? = nil) {
        Analytics.logEvent(EventName.refreshFailed, parameters: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus, error: error))
    }

    func logSortChanged(option: SortOption) {
        let (dimension, direction) = sortMetadata(option)
        Analytics.logEvent(EventName.sortChanged, parameters: [
            ParameterKey.sortDimension: dimension,
            ParameterKey.sortDirection: direction
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
        Analytics.logEvent(EventName.alertsFetchFailed, parameters: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus, error: error))
    }

    func logAlertsFetchEmpty(endpoint: String, httpStatus: Int? = nil) {
        Analytics.logEvent(EventName.alertsFetchEmpty, parameters: baseNetworkParams(endpoint: endpoint, httpStatus: httpStatus))
    }

    /// Logs the most recent horizontalAccuracy.
    /// - Parameters:
    ///   - location: The latest location.
    ///   - badThresholdMeters: "Bad" accuracy cutoff.
    ///   - extremeThresholdMeters: "Extreme" cutoff (likely useless).  (~31 miles).
    func logLocationAccuracy(
        _ location: CLLocation,
        badThresholdMeters: CLLocationAccuracy = 10_000,
        extremeThresholdMeters: CLLocationAccuracy = 50_000
    ) {
        let accuracy = location.horizontalAccuracy
        guard accuracy >= 0 else { return } // negative means invalid

        let isBad = accuracy >= badThresholdMeters
        let isExtreme = accuracy >= extremeThresholdMeters

        Analytics.logEvent(EventName.locationAccuracy, parameters: [
            ParameterKey.locationAccuracyM: accuracy,
            ParameterKey.accuracyBad: isBad ? 1 : 0,
            ParameterKey.accuracyExtreme: isExtreme ? 1 : 0
        ])
    }
}
