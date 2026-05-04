//
//  City.swift
//  Active Dispatch
//

import Foundation

// MARK: - Adding a new city
// 1. Add a case to the enum
// 2. Fill in all switch statement cases below
// 3. Create Cities/<Name>/City+<Name>.swift with <name>Theme and <name>Badge(for:)
// 4. Add assets to Assets.xcassets (header image, splash logo)

enum City: String, CaseIterable {
    case nashville
    case pdx
    case sf

    // MARK: - Display

    var displayName: String {
        switch self {
        case .nashville: return "Nashville"
        case .pdx:       return "Portland"
        case .sf:        return "San Francisco"
        }
    }

    // MARK: - API

    var apiSlug: String {
        switch self {
        case .nashville: return "nashville"
        case .pdx:       return "pdx"
        case .sf:        return "sf"
        }
    }

    // MARK: - Assets

    var headerImageName: String {
        switch self {
        case .nashville: return "nashvilleHeader"
        case .pdx:       return "pdxHeader"
        case .sf:        return "sfHeader"
        }
    }

    var splashLogoName: String {
        switch self {
        case .nashville: return "activedispatch-logo"
        case .pdx:       return "pdx_splash_logo"
        case .sf:        return "sf_splash_logo"
        }
    }

    // MARK: - Theme (defined in Cities/<Name>/City+<Name>.swift)

    var theme: CityTheme {
        switch self {
        case .nashville: return nashvilleTheme
        case .pdx:       return pdxTheme
        case .sf:        return sfTheme
        }
    }

    // MARK: - Badge logic (defined in Cities/<Name>/City+<Name>.swift)

    func badge(for place: Place) -> AlertBadge {
        switch self {
        case .nashville: return nashvilleBadge(for: place)
        case .pdx:       return pdxBadge(for: place)
        case .sf:        return sfBadge(for: place)
        }
    }
}
