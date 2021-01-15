//
//  MapNavigationView.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 1/10/21.
//

import UIKit

protocol MapNavigationViewDelegate: class {
    func didPressArrowButton (direction: ArrowDirection)
}

class MapNavigationView: UIView {

    let leftArrowButton = ADArrowButton(direction: .left)
    let rightArrowButton = ADArrowButton(direction: .right)
    let addressLabel = AlertTitleLabel(fontSize: 18)
    let timeLabel = AlertBodyLabel(fontSize: 14)
    
    weak var delegate: MapNavigationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews(leftArrowButton, rightArrowButton, addressLabel, timeLabel)
        translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textAlignment = .center
        timeLabel.textAlignment = .center
        
        let padding: CGFloat = 10
        let arrowSize: CGFloat = 36
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5),
            
            timeLabel.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: padding),
            timeLabel.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -padding),
            timeLabel.heightAnchor.constraint(equalToConstant: 16),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            leftArrowButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            leftArrowButton.widthAnchor.constraint(equalToConstant: arrowSize),
            leftArrowButton.heightAnchor.constraint(equalToConstant: arrowSize),
            leftArrowButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            rightArrowButton.heightAnchor.constraint(equalToConstant: arrowSize),
            rightArrowButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            rightArrowButton.widthAnchor.constraint(equalToConstant: arrowSize),
            rightArrowButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    
    private func configureButtons() {
        
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
        
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
    }
    
    
    func set(address: String?, time: String?) {
        addressLabel.text = address ?? ""
        timeLabel.text = time ?? ""
    }
    
    
    @objc private func arrowButtonTapped(_ sender: UIButton) {
        if sender == leftArrowButton {
            delegate?.didPressArrowButton(direction: .left)
        } else {
            delegate?.didPressArrowButton(direction: .right)
        }
    }
}
