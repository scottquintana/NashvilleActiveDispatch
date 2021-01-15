//
//  AlertBodyLabel.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/30/20.
//

import UIKit

class AlertBodyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat) {
        self.init(frame: .zero)
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            font = systemFont
        }
    }
    
    
    private func configure() {
        textColor = Colors.detailText
        adjustsFontSizeToFitWidth = false
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
