//
//  ADCloseButton.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 1/7/21.
//

import UIKit

class ADCloseButton: UIButton {

    let chevronDown = UIImageView()
    let closeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureLabel()
        configureChevron()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubviews(chevronDown, closeLabel)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            closeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            closeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            closeLabel.widthAnchor.constraint(equalToConstant: 60),
            closeLabel.heightAnchor.constraint(equalToConstant: 16),
            
            chevronDown.centerXAnchor.constraint(equalTo: closeLabel.trailingAnchor, constant: 4),
            chevronDown.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronDown.widthAnchor.constraint(equalToConstant: 16),
            chevronDown.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    private func configureLabel() {
        closeLabel.translatesAutoresizingMaskIntoConstraints = false
        closeLabel.text = "CLOSE"
        closeLabel.textAlignment = .center
        closeLabel.textColor = .black
        
        let systemFont = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            closeLabel.font = UIFont(descriptor: descriptor, size: 12)
        } else {
            closeLabel.font = systemFont
        }
    }
    
    
    private func configureChevron() {
        chevronDown.translatesAutoresizingMaskIntoConstraints = false
        chevronDown.image = SFSymbols.chevronDown
        chevronDown.tintColor = .black
    }
}
