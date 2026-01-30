//
//  IncidentViewModel.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit
import CoreLocation

class IncidentViewModel {
    let alertData: Place!
    var incidentLocation: CLLocation
    
    var incidentDescription: String {
        return alertData.extras.incidentTypeName.capitalized
    }
    
    var timeSinceCall: String {
        let callDate = DateHelper.convertISO8601ToDate(alertData.callTimeReceived)
        let timeInterval: TimeInterval = abs(callDate.timeIntervalSinceNow)
        if timeInterval < 3599 {
            return "\(timeInterval.format(using: [.minute])!) ago"
        } else {
            return "\(timeInterval.format(using: [.hour, .minute])!) ago"
        }
    }
    
    var callReceivedDate: String {
        return DateHelper.convertISO8601ToDateString(alertData.callTimeReceived)
    }
    
    var callReceivedTime: String {
        return DateHelper.convertISO8601ToTimeString(alertData.callTimeReceived)
    }
    
    var lastUpdatedDate: String {
        guard let date = alertData.updatedAt else { return "N/A" }
        return DateHelper.convertISO8601ToDateString(date)
    }
    
    var lastUpdatedTime: String {
        guard let time = alertData.updatedAt else { return "N/A" }
        return DateHelper.convertISO8601ToTimeString(time)
    }
    
    var neighborhood: String {
        // Extract neighborhood from address (after first comma)
        let components = alertData.address.components(separatedBy: ", ")
        return components.count > 1 ? components[1].capitalized : ""
    }
    
    var locationString: String {
        return "\(neighborhood) - \(streetAddress)"
    }
    
    var streetAddress: String {
        // Extract street address (before first comma)
        let components = alertData.address.components(separatedBy: ", ")
        return components.first?.capitalized ?? alertData.address.capitalized
    }
    
    var fullAddress: String {
        return alertData.address
    }
    
    init(alert: Place) {
        self.alertData = alert
        // Use the coordinates directly from the API instead of geocoding
        self.incidentLocation = CLLocation(latitude: alert.lat, longitude: alert.lon)
    }
}

extension String {
    var normalizedPDXType: String {
        uppercased()
            .replacingOccurrences(of: " *H", with: "")
            .replacingOccurrences(of: " - PRIORITY", with: "")
            .replacingOccurrences(of: " - COLD", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
