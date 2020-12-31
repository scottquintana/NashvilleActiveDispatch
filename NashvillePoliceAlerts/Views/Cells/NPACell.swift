//
//  NPACell.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit

class NPACell: UITableViewCell {

    static let reuseID = "NPACell"
    
    var alertViewModel: ViewModel! {
        didSet {
            addressLabel.text = "Address: \(alertViewModel.streetAddress)"
        }
    }
    
    let addressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        let containerView = GradientView()
        contentView.addSubview(containerView)
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        
        containerView.addSubview(addressLabel)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .label
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            addressLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addressLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            addressLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
