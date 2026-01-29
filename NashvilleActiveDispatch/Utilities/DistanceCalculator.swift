//
//  DistanceCalculator.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/28/26.
//

import Foundation
import CoreLocation

class DistanceCalculator {
    
    static func distanceInMiles(from userLocation: CLLocation?, to incidentLocation: CLLocation) -> Double? {
        guard let userLocation = userLocation else { return nil }
        let distanceInMeters = userLocation.distance(from: incidentLocation)
        let distance = Measurement(value: distanceInMeters, unit: UnitLength.meters)
        let miles = distance.converted(to: .miles)
        return miles.value
    }
    
    static func distanceString(from userLocation: CLLocation?, to incidentLocation: CLLocation, neighborhood: String) -> String {
        guard let miles = distanceInMiles(from: userLocation, to: incidentLocation) else {
            return "Calculating distance..."
        }
        let milesString = String(format: "%.1f", miles)
        return "\(neighborhood) - \(milesString) mi. away"
    }
}
