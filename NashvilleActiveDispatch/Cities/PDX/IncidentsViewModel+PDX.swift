//
//  IncidentsViewModel+PDX.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/29/26.
//

import Foundation

extension IncidentViewModel {
    var incidentBadge: AlertBadge {
        let rawType = alertData.extras.incidentTypeName
        let type = rawType.normalizedPDXType
        
        switch type {
            
            // MARK: - Weapons / Immediate danger
        case "DISTURBANCE - WITH WEAPON",
            "SUSPICIOUS - WITH WEAPON",
            "THREAT",
            "BURGLARY":
            return AlertBadge(
                color: Colors.accentRed,
                symbol: SFSymbols.sheildExclamation!
            )
        case let t where t.hasPrefix("THREAT"):
            return AlertBadge(
                color: Colors.accentRed,
                symbol: SFSymbols.sheildExclamation!
            )
            
            // MARK: - Fire / alarm / explosion risk
        case "ALMCOM - MONITORED COMMERCIAL FIRE ALARM",
            "MISCF - UNKNOWN TYPE OF FIRE PROBLEM":
            return AlertBadge(
                color: Colors.accentRed,
                symbol: SFSymbols.triangleExclamation!
            )
            
            // MARK: - Self-harm / jumper
        case "JUMP - POTENTIAL JUMPER":
            return AlertBadge(
                color: Colors.accentRed,
                symbol: SFSymbols.personExclamation!
            )
            
            // MARK: - Traffic incidents
        case let t where t.hasPrefix("ACCIDENT"):
            return AlertBadge(
                color: Colors.accentGold,
                symbol: SFSymbols.car!
            )
            
            // MARK: - Property crime (non-violent)
        case "THEFT",
            "VEHICLE STOLEN",
            "VANDALISM":
            return AlertBadge(
                color: Colors.accentLightPurple,
                symbol: SFSymbols.sheildExclamation!
            )
        case "ILLEGAL DUMPING":
            return AlertBadge(
                color: Colors.accentLightPurple,
                symbol: SFSymbols.trashSlash!
            )
            
            // MARK: - Hazards / infrastructure issues
        case "HAZARD - HAZARDOUS CONDITION":
            return AlertBadge(
                color: Colors.accentGold,
                symbol: SFSymbols.hazard!
            )
            
            // MARK: - General police presence / checks
        case "SUSPICIOUS SUBJ, VEH, OR CIRCUMSTANCE",
            "PUBAST - PUBLIC ASSIST":
            return AlertBadge(
                color: Colors.accentGold,
                symbol: SFSymbols.bell!
            )
        case "AREA CHECK",
            "PREMISE CHECK":
            return AlertBadge(
                color: Colors.accentBlue,
                symbol: SFSymbols.flashlight!
            )
        case "UNWANTED PERSON":
            return AlertBadge(
                color: Colors.accentGold,
                symbol: SFSymbols.noPerson!
            )
            
        default:
            return AlertBadge(
                color: Colors.accentGold,
                symbol: SFSymbols.bell!
            )
        }
    }
}
