//
//  ViewModel.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit
import CoreLocation

class IncidentViewModel {
    let alertData: IncidentData!
    var incidentLocation = CLLocationCoordinate2D()
    
    var incidentDescription: String {
        return alertData.incidentType.capitalized
    }
    
    var callReceivedDate: String {
      return DateHelper.convertStringToDateString(alertData.callReceived)
    }
    
    var callReceivedTime: String {
        return DateHelper.convertStringToTimeString(alertData.callReceived)
    }
    
    var lastUpdatedDate: String {
        return DateHelper.convertStringToDateString(alertData.lastUpdated)
    }
    
    var lastUpdatedTime: String {
        return DateHelper.convertStringToTimeString(alertData.lastUpdated)
    }
    
    var neighborhood: String {
        return alertData.city.capitalized
    }
    
    var locationString: String {
        return "\(neighborhood) - \(streetAddress)"
    }
    
    var streetAddress: String {
        return "\(alertData.address.capitalized)"
    }
    
    var fullAddress: String {
        return "\(streetAddress) Nashville, TN"
    }
    
    var incidentBadge: AlertBadge {
        switch alertData.incidentTypeCode {
        case "53P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.bell!)
        case "70A":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.bell!)
        case "71A":
            return AlertBadge(color: Colors.accentLightPurple, symbol: SFSymbols.business!)
        case "64P":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.medical!)
        case "83P", "51P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.sheildExclamation!)
        case "87T":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.treeDown!)
        case "87W":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.wiresDown!)
        default:
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.bell!)
        }
    }
    
    init(alert: IncidentData) {
        self.alertData = alert
        getLocation(address: fullAddress)
    }
    
    
    func getLocation(address: String) {
        LocationManager.coordinates(forAddress: fullAddress) { location in
            guard let location = location else { return }
            self.incidentLocation = location
        }
    }
    
}
