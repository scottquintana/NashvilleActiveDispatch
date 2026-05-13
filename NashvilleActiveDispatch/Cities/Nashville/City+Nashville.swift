//
//  City+Nashville.swift
//  Active Dispatch
//

import UIKit

extension City {

    var nashvilleTheme: CityTheme {
        CityTheme(
            background:       UIColor(red: 0.06, green: 0.05, blue: 0.27, alpha: 1.00),
            gradientTop:      UIColor(red: 0.14, green: 0.13, blue: 0.38, alpha: 1.00),
            gradientBottom:   UIColor(red: 0.19, green: 0.19, blue: 0.46, alpha: 1.00),
            buttonColor:      UIColor(red: 0.20, green: 0.33, blue: 0.98, alpha: 1.00),
            detailText:       UIColor(red: 0.49, green: 0.55, blue: 0.73, alpha: 1.00),
            danger:    UIColor(red: 0.94, green: 0.20, blue: 0.38, alpha: 1.00),
            warning:   UIColor(red: 0.97, green: 0.58, blue: 0.15, alpha: 1.00),
            info:      UIColor(red: 0.23, green: 0.62, blue: 0.96, alpha: 1.00),
            safe:      UIColor(red: 0.30, green: 0.89, blue: 0.39, alpha: 1.00),
            secondary: UIColor(red: 0.38, green: 0.50, blue: 0.92, alpha: 1.00)
        )
    }

    func nashvilleBadge(for place: Place) -> AlertBadge {
        let t = nashvilleTheme
        switch place.extras.incidentTypeCode {
        case "52P", "53P":
            return AlertBadge(color: t.danger, symbol: SFSymbols.bell!)
        case "70A", "70P":
            return AlertBadge(color: t.safe, symbol: SFSymbols.bell!)
        case "71A", "71P":
            return AlertBadge(color: t.secondary, symbol: SFSymbols.business!)
        case "64P":
            return AlertBadge(color: t.warning, symbol: SFSymbols.personExclamation!)
        case "83P", "51P":
            return AlertBadge(color: t.danger, symbol: SFSymbols.sheildExclamation!)
        case "87T":
            return AlertBadge(color: t.safe, symbol: SFSymbols.treeDown!)
        case "87W":
            return AlertBadge(color: t.warning, symbol: SFSymbols.wiresDown!)
        case "8000":
            return AlertBadge(color: t.danger, symbol: SFSymbols.triangleExclamation!)
        default:
            return AlertBadge(color: t.warning, symbol: SFSymbols.bell!)
        }
    }
}
