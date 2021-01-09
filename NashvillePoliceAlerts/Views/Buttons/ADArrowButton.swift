//
//  ADArrowButton.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/7/21.
//

import UIKit

class ADArrowButton: UIButton {

    let arrowImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(direction: ArrowDirection) {
        self.init()
        configure(arrowDirection: direction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(arrowDirection: ArrowDirection) {
        addSubview(arrowImage)
        arrowImage.pinToEdges(of: self)
        arrowImage.adjustsImageSizeForAccessibilityContentSizeCategory = false
        
        switch arrowDirection {
        case .left:
            arrowImage.image = SFSymbols.arrowLeft
        case .right:
            arrowImage.image = SFSymbols.arrowRight
        }
        
        arrowImage.tintColor = .white
    }
}
