//
//  ViewModel.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

class ViewModel {
    let alertData: NADData!
        
    var incident: String {
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
        case "70A":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.residence!)
        case "71A":
            return AlertBadge(color: Colors.accentLightPurple, symbol: SFSymbols.business!)
        case "64P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.medical!)
        case "83P":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.triangleExclamation!)
        default:
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.bell!)
        }
    }
    
    init(alert: NADData) {
        self.alertData = alert
    }
    
}
