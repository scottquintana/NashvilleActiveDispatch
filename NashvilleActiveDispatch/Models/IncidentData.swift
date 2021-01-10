//
//  IncidentData.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import Foundation

struct IncidentData: Codable {
    let incidentTypeCode: String
    let incidentType: String
    let callReceived: String
    let lastUpdated: String
    let address: String
    let city: String
}
