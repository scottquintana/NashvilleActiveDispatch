//
//  GradientView.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

final class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()

    private var color1: CGColor = Colors.gradientTop.cgColor
    private var color2: CGColor = Colors.gradientBottom.cgColor

    convenience init(cgColor1: CGColor, cgColor2: CGColor) {
        self.init(frame: .zero)
        color1 = cgColor1
        color2 = cgColor2
        updateGradientColors()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradientColors()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func updateGradientColors() {
        gradientLayer.colors = [color1, color2]
    }

    func updateColor(newTop: CGColor) {
        color1 = newTop
        updateGradientColors()
    }
}
