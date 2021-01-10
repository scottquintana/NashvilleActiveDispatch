//
//  ADAlertContainerView.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/7/21.
//

import UIKit

class ADAlertContainerView: UIView {
    
    let gradientView = GradientView(cgColor1: Colors.gradientTop.cgColor, cgColor2: Colors.gradientBottom.cgColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(gradientView)
        gradientView.pinToEdges(of: self)
        
        gradientView.layer.cornerRadius = 24
        gradientView.layer.borderWidth = 1
        gradientView.layer.borderColor = Colors.accentLightPurple.cgColor
        gradientView.clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
