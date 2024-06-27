//
//  IncidentData.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import Foundation

//struct IncidentData: Codable {
//    let incidentTypeCode: String
//    let incidentType: String
//    let callReceived: String
//    let lastUpdated: String
//    let address: String
//    let city: String
//}

struct DispatchPayload: Codable {
    let features: [Features]
}
struct Features: Codable {
    let type: String
    let id: Int
    let geometry: Geometry?
    let properties: IncidentData
}

// Define the properties struct
struct IncidentData: Codable {
    let incidentTypeCode: String
    let incidentTypeName: String
    let callReceivedTime: Int64
    let location: String
    let locationDescription: String?
    let cityName: String
    let lastUpdated: Int64
    let objectId: Int
    
    // Coding keys to match the JSON keys with the struct properties
    enum CodingKeys: String, CodingKey {
        case incidentTypeCode = "IncidentTypeCode"
        case incidentTypeName = "IncidentTypeName"
        case callReceivedTime = "CallReceivedTime"
        case location = "Location"
        case locationDescription = "LocationDescription"
        case cityName = "CityName"
        case lastUpdated = "LastUpdated"
        case objectId = "ObjectId"
    }
}

// Define the geometry struct (as it's null in the provided JSON, this can be optional)
struct Geometry: Codable {
    // Define the properties of Geometry if known
}
