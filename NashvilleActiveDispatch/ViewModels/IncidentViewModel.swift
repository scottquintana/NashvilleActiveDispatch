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
        return DateHelper.convertISO8601ToDateString(alertData.updatedAt)
    }
    
    var lastUpdatedTime: String {
        return DateHelper.convertISO8601ToTimeString(alertData.updatedAt)
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
        
    var incidentBadge: AlertBadge {
        switch alertData.extras.incidentTypeCode {
        case "52P", "53P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.bell!)
        case "70A", "70P":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.bell!)
        case "71A", "71P":
            return AlertBadge(color: Colors.accentLightPurple, symbol: SFSymbols.business!)
        case "64P":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.personExclamation!)
        case "83P", "51P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.sheildExclamation!)
        case "87T":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.treeDown!)
        case "87W":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.wiresDown!)
        case "8000":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.triangleExclamation!)
        default:
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.bell!)
        }
    }
    
    init(alert: Place) {
        self.alertData = alert
        // Use the coordinates directly from the API instead of geocoding
        self.incidentLocation = CLLocation(latitude: alert.lat, longitude: alert.lon)
    }
}
