//
//  City+SF.swift
//  Active Dispatch
//
//

import UIKit

extension City {

    var sfTheme: CityTheme {
        CityTheme(
            // Matches the near-black hills / foreground of the SF header
            background:        UIColor(red: 0.08, green: 0.09, blue: 0.08, alpha: 1.00),
           
            // Muted SF flag-inspired gold gradient
            gradientTop:       UIColor(red: 0.52, green: 0.36, blue: 0.10, alpha: 1.00),
            gradientBottom:    UIColor(red: 0.34, green: 0.24, blue: 0.09, alpha: 1.00),

            // Deep flag/navy-inspired button
            buttonColor:       UIColor(red: 0.05, green: 0.15, blue: 0.34, alpha: 1.00),

            // Warm muted detail text that works over the dark body
            detailText:        UIColor(red: 0.74, green: 0.62, blue: 0.39, alpha: 1.00),

            danger:    UIColor(red: 0.98, green: 0.22, blue: 0.18, alpha: 1.00),
            warning:   UIColor(red: 0.98, green: 0.62, blue: 0.08, alpha: 1.00),
            info:      UIColor(red: 0.25, green: 0.65, blue: 0.92, alpha: 1.00),
            safe:      UIColor(red: 0.46, green: 0.56, blue: 0.28, alpha: 1.00),
            secondary: UIColor(red: 0.70, green: 0.52, blue: 0.28, alpha: 1.00)
        )
    }

    func sfBadge(for place: Place) -> AlertBadge {
        let t = sfTheme
        let type = place.extras.incidentTypeName.uppercased().trimmingCharacters(in: .whitespaces)

        switch type {

        // MARK: - Violent / Immediate danger
        case "STABBING",
             "PERSON W/GUN",
             "ASSAULT / BATTERY",
             "STRONGARM ROBBERY",
             "THREATS / HARASSMENT",
             "STALKING",
             "BURGLARY":
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)

        case "FIGHT NO WEAPON",
             "WANTED VEHICLE / SUB":
            return AlertBadge(color: t.warning, symbol: SFSymbols.sheildExclamation!)

        case "INJURY VEH ACCIDENT":
            return AlertBadge(color: t.danger, symbol: SFSymbols.triangleExclamation!)

        // MARK: - Person in distress
        case "PERSON SCREAMING",
             "MENTALLY DISTURBED":
            return AlertBadge(color: t.warning, symbol: SFSymbols.personExclamation!)

        case "WELL BEING CHECK",
             "HOMELESS COMPLAINT":
            return AlertBadge(color: t.info, symbol: SFSymbols.personExclamation!)

        // MARK: - Suspicious activity
        case "SUSPICIOUS PERSON":
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)

        case "PROWLER":
            return AlertBadge(color: t.warning, symbol: SFSymbols.flashlight!)

        case "TRESPASSER":
            return AlertBadge(color: t.warning, symbol: SFSymbols.noPerson!)

        // MARK: - Vehicle incidents
        case "AUTO BOOST / STRIP",
             "SUSPICIOUS VEHICLE":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.car!)

        case "VEH ACCIDENT":
            return AlertBadge(color: t.info, symbol: SFSymbols.car!)

        // MARK: - Traffic / Hazard
        case "TRAFFIC HAZARD":
            return AlertBadge(color: t.warning, symbol: SFSymbols.triangleExclamation!)

        // MARK: - Property crime
        case "VANDALISM":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.scribble!)

        case "FRAUD",
             "PETTY THEFT":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.sheildExclamation!)

        // MARK: - Quality of life
        case "NOISE NUISANCE":
            return AlertBadge(color: t.info, symbol: SFSymbols.bell!)

        // MARK: - Administrative / Resolved
        case "ARREST MADE",
             "CITIZEN ARREST":
            return AlertBadge(color: t.safe, symbol: SFSymbols.sheildExclamation!)

        case "PRISONER TRANSPORT",
             "MEET W/CITIZEN",
             "MEET W/CITY EMPLOYEE",
             "CITIZEN STANDBY":
            return AlertBadge(color: t.info, symbol: SFSymbols.bell!)

        case "SIT/LIE ENFORCEMENT":
            return AlertBadge(color: t.info, symbol: SFSymbols.noPerson!)

        case "TRAF VIOLATION TOW",
             "TRAF VIOLATION CITE",
             "TOW TRUCK":
            return AlertBadge(color: t.info, symbol: SFSymbols.car!)

        default:
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)
        }
    }
}
