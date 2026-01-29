//
//  LocationManager.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 1/4/21.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateCurrentLocation()
}

final class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    static let shared: LocationManager = {
        LocationManager()
    }()
    
    private let locationManager = CLLocationManager()
    
    private(set) var currentLocation: CLLocation?
    
    var coords: CLLocation? {
        currentLocation
    }
    
    override init() {
        super.init()
        configureManager()
        // Initial evaluation: do NOT call locationServicesEnabled() on main.
        evaluateAuthorizationAndStartIfNeeded()
    }
    
    // MARK: - Setup
    
    private func configureManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    // MARK: - Authorization / Start
    
    private func evaluateAuthorizationAndStartIfNeeded() {
        let status = currentAuthorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingIfServicesEnabled()
            
        case .restricted:
            AnalyticsManager.shared.logLocationPermissionRestricted()
            locationManager.stopUpdatingLocation()
            
        case .denied:
            AnalyticsManager.shared.logLocationPermissionDenied()
            locationManager.stopUpdatingLocation()
            
        @unknown default:
            AnalyticsManager.shared.logError(
                type: "LocationManager",
                message: "Unknown authorization status",
                context: "status: \(status.rawValue)"
            )
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func startUpdatingIfServicesEnabled() {
        // Do the potentially "blocking" call off-main, then hop back to main for startUpdatingLocation.
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let enabled = CLLocationManager.locationServicesEnabled()
            
            DispatchQueue.main.async {
                guard let self else { return }
                
                if enabled {
                    self.locationManager.startUpdatingLocation()
                } else {
                    // Services disabled at OS level.
                    AnalyticsManager.shared.logLocationServicesDisabled()
                    AnalyticsManager.shared.logError(ADError.invalidLocation, context: "LocationManager")
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    private func currentAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    // MARK: - Public
    
    func getLocation() -> CLLocation? {
        currentLocation
    }
    
    static func coordinates(forAddress address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard error == nil else {
                let errorMessage = error!.localizedDescription
                AnalyticsManager.shared.logError(
                    type: "GeocodingError",
                    message: errorMessage,
                    context: "address: \(address)"
                )
                completion(nil)
                return
            }
            completion(placemarks?.first?.location)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        AnalyticsManager.shared.logLocationAccuracy(location)
        
        delegate?.didUpdateCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AnalyticsManager.shared.logError(
            type: "CLLocationManagerError",
            message: error.localizedDescription,
            context: "LocationManager delegate"
        )
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Called whenever auth changes; this is the preferred "re-evaluate" hook.
        evaluateAuthorizationAndStartIfNeeded()
    }
}
