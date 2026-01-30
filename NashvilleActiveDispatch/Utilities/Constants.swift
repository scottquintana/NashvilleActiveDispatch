//
//  Constants.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

enum Colors {
    //    static let background = UIColor(red: 0.06, green: 0.05, blue: 0.27, alpha: 1.00)
    //    static let gradientTop = UIColor(red: 0.14, green: 0.13, blue: 0.38, alpha: 1.00)
    //    static let gradientBottom = UIColor(red: 0.19, green: 0.19, blue: 0.46, alpha: 1.00)
    //
    //    static let buttonBlue = UIColor(red: 0.20, green: 0.33, blue: 0.98, alpha: 1.00)
    //    static let accentGold = UIColor(red: 0.97, green: 0.58, blue: 0.15, alpha: 1.00)
    //    static let accentRed = UIColor(red: 0.94, green: 0.20, blue: 0.38, alpha: 1.00)
    //    static let accentBlue = UIColor(red: 0.23, green: 0.62, blue: 0.96, alpha: 1.00)
    //    static let accentGreen = UIColor(red: 0.30, green: 0.89, blue: 0.39, alpha: 1.00)
    //    static let accentLightPurple = UIColor(red: 0.38, green: 0.50, blue: 0.92, alpha: 1.00)
    //    static let detailText = UIColor(red: 0.49, green: 0.55, blue: 0.73, alpha: 1.00)
    // High-contrast emerald palette (icon-forward)

    static let background = UIColor(
        red: 0.07,
        green: 0.18,
        blue: 0.14,
        alpha: 1.00
    )

    static let gradientTop = UIColor(
        red: 0.09,
        green: 0.24,
        blue: 0.18,
        alpha: 1.00
    )

    static let gradientBottom = UIColor(
        red: 0.12,
        green: 0.30,
        blue: 0.22,
        alpha: 1.00
    )

    static let buttonBlue = UIColor(
        red: 0.14,
        green: 0.42,
        blue: 0.34,
        alpha: 1.00
    )

    static let accentGold = UIColor(
        red: 0.93,
        green: 0.72,
        blue: 0.36,
        alpha: 1.00
    )

    static let accentRed = UIColor(
        red: 0.86,
        green: 0.30,
        blue: 0.40,
        alpha: 1.00
    )

    static let accentBlue = UIColor(
        red: 0.38,
        green: 0.70,
        blue: 0.65,
        alpha: 1.00
    )

    static let accentGreen = UIColor(
        red: 0.10,
        green: 0.68,
        blue: 0.52,
        alpha: 1.00
    )

    static let accentLightPurple = UIColor(
        red: 0.46,
        green: 0.74,
        blue: 0.63,
        alpha: 1.00
    )

    static let detailText = UIColor(
        red: 0.72,
        green: 0.84,
        blue: 0.78,
        alpha: 1.00
    )
}

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
    static let sheild = UIImage(systemName: "exclamationmark.sheild.fill")
    static let noPerson = UIImage(systemName: "person.badge.minus")
    static let personExclamation = UIImage(systemName: "person.crop.circle.fill.badge.exclamationmark")
    static let residence = UIImage(systemName: "house.circle.fill")
    static let roadBlock = UIImage(systemName: "road.lanes")
    static let trashSlash = UIImage(systemName: "trash.slash")
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
