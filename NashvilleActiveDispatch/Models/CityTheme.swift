//
//  CityTheme.swift
//  Active Dispatch
//

import UIKit

struct CityTheme {
    // Layout colors
    let background: UIColor
    let gradientTop: UIColor
    let gradientBottom: UIColor
    let buttonColor: UIColor
    let detailText: UIColor
    // Incident severity accent colors — named by role, not color,
    // so each city can choose values that pop against their own palette.
    let danger: UIColor     // highest priority / violent incidents
    let warning: UIColor    // moderate concern
    let info: UIColor       // informational / low priority
    let safe: UIColor       // resolved / environmental
    let secondary: UIColor  // administrative / background
}
