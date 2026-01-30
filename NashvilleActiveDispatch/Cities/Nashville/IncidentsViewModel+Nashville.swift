//
//  IncidentsViewModel+PDX.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/29/26.
//

import Foundation

extension IncidentViewModel {
    var incidentBadge: AlertBadge {
        switch alertData.extras.incidentTypeCode {
        case "52P", "53P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.bell!)
        case "70A", "70P":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.bell!)
        case "71A", "71P":
            return AlertBadge(color: Colors.accentLightPurple, symbol: SFSymbols.business!)
        case "64P":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.personExclamation!)
        case "83P", "51P":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.sheildExclamation!)
        case "87T":
            return AlertBadge(color: Colors.accentGreen, symbol: SFSymbols.treeDown!)
        case "87W":
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.wiresDown!)
        case "8000":
            return AlertBadge(color: Colors.accentRed, symbol: SFSymbols.triangleExclamation!)
        default:
            return AlertBadge(color: Colors.accentGold, symbol: SFSymbols.bell!)
        }
    }
}
