//
//  GradientView.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

class GradientView: UIView {

    var color1: CGColor = Colors.gradientTop.cgColor
    var color2: CGColor = Colors.gradientBottom.cgColor

    convenience init(cgColor1: CGColor, cgColor2: CGColor) {
        self.init(frame: .zero)
        color1 = cgColor1
        color2 = cgColor2
    }
    
    override func layoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color1, color2]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func updateColor(newTop: CGColor) {
        color1 = newTop
        layoutSubviews()
    }

}
