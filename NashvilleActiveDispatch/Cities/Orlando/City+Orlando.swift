//
//  City+Orlando.swift
//  Active Dispatch
//

import UIKit

extension City {

    var orlandoTheme: CityTheme {
        CityTheme(
            background:     UIColor(red: 0.00, green: 0.07, blue: 0.16, alpha: 1.00),
            gradientTop:    UIColor(red: 0.03, green: 0.15, blue: 0.30, alpha: 1.00),
            gradientBottom: UIColor(red: 0.14, green: 0.11, blue: 0.20, alpha: 1.00),
            buttonColor:    UIColor(red: 0.95, green: 0.56, blue: 0.18, alpha: 1.00),
            detailText:     UIColor(red: 0.70, green: 0.80, blue: 0.88, alpha: 1.00),
            danger:         UIColor(red: 0.93, green: 0.38, blue: 0.26, alpha: 1.00),
            warning:        UIColor(red: 0.97, green: 0.73, blue: 0.28, alpha: 1.00),
            info:           UIColor(red: 0.35, green: 0.66, blue: 0.98, alpha: 1.00),
            safe:           UIColor(red: 0.28, green: 0.74, blue: 0.58, alpha: 1.00),
            secondary:      UIColor(red: 0.72, green: 0.64, blue: 0.90, alpha: 1.00)
        )
    }

    func orlandoBadge(for place: Place) -> AlertBadge {
        let t = orlandoTheme
        let type = place.extras.incidentTypeName.normalizedORLType

        switch type {

        // MARK: - Weapons / Violence
        case let s where s.contains("SHOOTING") || s.contains("STABBING") || s.contains("WEAPON"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)
        case let s where s.contains("ROBBERY") || s.contains("ASSAULT") || s.contains("BATTERY"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)

        // MARK: - Medical / Down
        case let s where s.contains("MAN DOWN") || s.contains("PERSON DOWN") || s.contains("UNCONSCIOUS"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.personExclamation!)
        case let s where s.contains("OVERDOSE"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.personExclamation!)

        // MARK: - Traffic
        case let s where s.contains("ACCIDENT") || s.contains("CRASH") || s.contains("HIT AND RUN"):
            return AlertBadge(color: t.warning, symbol: SFSymbols.car!)

        // MARK: - Fire / Hazard
        case let s where s.contains("FIRE") || s.contains("EXPLOSION"):
            return AlertBadge(color: t.danger, symbol: SFSymbols.triangleExclamation!)
        case let s where s.contains("HAZARD"):
            return AlertBadge(color: t.warning, symbol: SFSymbols.hazard!)

        // MARK: - Property crime
        case let s where s.contains("BURGLARY") || s.contains("THEFT") || s.contains("STOLEN"):
            return AlertBadge(color: t.secondary, symbol: SFSymbols.sheildExclamation!)
        case let s where s.contains("VANDALISM"):
            return AlertBadge(color: t.secondary, symbol: SFSymbols.sheildExclamation!)

        // MARK: - Suspicious
        case let s where s.contains("SUSPICIOUS"):
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)

        // MARK: - Disturbance
        case let s where s.contains("DISTURBANCE") || s.contains("FIGHT"):
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)

        default:
            return AlertBadge(color: t.info, symbol: SFSymbols.bell!)
        }
    }
}

// MARK: - ORL incident type normalization

private extension String {
    var normalizedORLType: String {
        uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
