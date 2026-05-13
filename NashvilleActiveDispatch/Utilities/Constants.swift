//
//  Constants.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

// All colors are now city-specific and live in CityTheme (see Models/CityTheme.swift).
// Access them via CityManager.shared.currentTheme or city.theme.

enum SFSymbols {
    static let arrowLeft = UIImage(systemName: "arrowtriangle.left.fill")
    static let arrowRight = UIImage(systemName: "arrowtriangle.right.fill")
    static let chevronDown = UIImage(systemName: "chevron.compact.down")
    static let triangleExclamation = UIImage(systemName: "exclamationmark.triangle.fill")
    static let bell = UIImage(systemName: "bell.circle.fill")
    static let car = UIImage(systemName: "car.circle.fill")
    static let flag = UIImage(systemName: "flag.circle.fill")
    static let flashlight = UIImage(systemName: "flashlight.on.circle.fill")
    static let hazard = UIImage(systemName: "exclamationmark.triangle")
    static let noPerson = UIImage(systemName: "person.badge.minus")
    static let roadBlock = UIImage(systemName: "road.lanes")
    static let trashSlash = UIImage(systemName: "trash.slash")
    static let scribble = UIImage(systemName: "scribble")
    static let personExclamation = UIImage(systemName: "person.crop.circle.fill.badge.exclamationmark")
    static let residence = UIImage(systemName: "house.circle.fill")
    static let business = UIImage(systemName: "building.2.crop.circle.fill")
    static let medical = UIImage(systemName: "cross.circle.fill")
    static let wiresDown = UIImage(systemName: "bolt.circle.fill")
    static let treeDown = UIImage(systemName: "arrow.down.right.circle.fill")
    static let sheildExclamation = UIImage(systemName: "exclamationmark.shield.fill")
    static let map = UIImage(systemName: "map.fill")
}

enum ArrowDirection {
    case left, right
}
