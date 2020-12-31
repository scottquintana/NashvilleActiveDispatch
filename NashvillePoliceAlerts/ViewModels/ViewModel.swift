//
//  ViewModel.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//

import Foundation

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
    
    init(alert: NADData) {
        self.alertData = alert
    }
    
}
