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

class LocationManager: NSObject {
    
    weak var delegate: LocationManagerDelegate?
    
    static let shared: LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    var currentLocation: CLLocation?
    
    var coords: CLLocation? {
        return currentLocation
    }
    
    var timer = 0
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
        checkLocationServices()
    }
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            
        } else {
            print(ADError.invalidLocation)
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func getLocation() -> CLLocation? {
        let coords = self.currentLocation
        return coords
    }
    static func coordinates(forAddress address: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentLocation = location
        delegate?.didUpdateCurrentLocation()
    
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
