//
//  ADPlusButton.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/8/21.
//

import UIKit

class ADMapButton: UIButton {

    let mapImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(mapImage)
        backgroundColor = Colors.buttonBlue
        

        mapImage.translatesAutoresizingMaskIntoConstraints = false
        mapImage.image = SFSymbols.map
        mapImage.tintColor = .white


        NSLayoutConstraint.activate([
            mapImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            mapImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mapImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            mapImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)

        ])
    }

}
