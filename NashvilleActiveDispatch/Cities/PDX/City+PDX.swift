//
//  City+PDX.swift
//  Active Dispatch
//

import UIKit

extension City {

    var pdxTheme: CityTheme {
        CityTheme(
            background:       UIColor(red: 0.07, green: 0.18, blue: 0.14, alpha: 1.00),
            gradientTop:      UIColor(red: 0.09, green: 0.24, blue: 0.18, alpha: 1.00),
            gradientBottom:   UIColor(red: 0.12, green: 0.30, blue: 0.22, alpha: 1.00),
            buttonColor:      UIColor(red: 0.14, green: 0.42, blue: 0.34, alpha: 1.00),
            detailText:       UIColor(red: 0.72, green: 0.84, blue: 0.78, alpha: 1.00),
            danger:    UIColor(red: 0.86, green: 0.30, blue: 0.40, alpha: 1.00),
            warning:   UIColor(red: 0.93, green: 0.72, blue: 0.36, alpha: 1.00),
            info:      UIColor(red: 0.38, green: 0.70, blue: 0.65, alpha: 1.00),
            safe:      UIColor(red: 0.10, green: 0.68, blue: 0.52, alpha: 1.00),
            secondary: UIColor(red: 0.46, green: 0.74, blue: 0.63, alpha: 1.00)
        )
    }

    func pdxBadge(for place: Place) -> AlertBadge {
        let t = pdxTheme
        let type = place.extras.incidentTypeName.normalizedPDXType

        switch type {

        // MARK: - Weapons / Immediate danger
        case "DISTURBANCE - WITH WEAPON",
             "SUSPICIOUS - WITH WEAPON",
             "THREAT",
             "BURGLARY":
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)
        case let s where s.hasPrefix("THREAT"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)

        // MARK: - Fire / alarm
        case "ALMCOM - MONITORED COMMERCIAL FIRE ALARM",
             "MISCF - UNKNOWN TYPE OF FIRE PROBLEM":
            return AlertBadge(color: t.danger, symbol: SFSymbols.triangleExclamation!)

        // MARK: - Self-harm / jumper
        case "JUMP - POTENTIAL JUMPER":
            return AlertBadge(color: t.danger, symbol: SFSymbols.personExclamation!)

        // MARK: - Traffic incidents
        case let s where s.hasPrefix("ACCIDENT"):
            return AlertBadge(color: t.warning, symbol: SFSymbols.car!)

        // MARK: - Property crime
        case "THEFT",
             "VEHICLE STOLEN",
             "VANDALISM":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.sheildExclamation!)
        case "ILLEGAL DUMPING":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.trashSlash!)

        // MARK: - Hazards
        case "HAZARD - HAZARDOUS CONDITION":
            return AlertBadge(color: t.warning, symbol: SFSymbols.hazard!)

        // MARK: - General police / checks
        case "SUSPICIOUS SUBJ, VEH, OR CIRCUMSTANCE",
             "PUBAST - PUBLIC ASSIST":
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)
        case "AREA CHECK",
             "PREMISE CHECK":
            return AlertBadge(color: t.info, symbol: SFSymbols.flashlight!)
        case "UNWANTED PERSON":
            return AlertBadge(color: t.warning, symbol: SFSymbols.noPerson!)

        default:
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)
        }
    }
}

// MARK: - PDX incident type normalization

private extension String {
    var normalizedPDXType: String {
        uppercased()
            .replacingOccurrences(of: " *H", with: "")
            .replacingOccurrences(of: " - PRIORITY", with: "")
            .replacingOccurrences(of: " - COLD", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
