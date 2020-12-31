//
//  GradientView.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

class GradientView: UIView {

    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [Colors.gradientTop.cgColor, Colors.gradientBottom.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }

}
