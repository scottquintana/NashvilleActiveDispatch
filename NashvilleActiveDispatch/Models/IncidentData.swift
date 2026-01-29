//
//  IncidentData.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import Foundation

struct DispatchPayload: Codable {
    let city: String
    let source: String
    let fetchedAt: String
    let places: [Place]
}

struct Place: Codable {
    let id: String
    let name: String
    let lat: Double
    let lon: Double
    let address: String
    let callTimeReceived: String
    let updatedAt: String?
    let extras: IncidentExtras
}

struct IncidentExtras: Codable {
    let incidentTypeCode: String?
    let incidentTypeName: String
    let incidentId: String?
}
