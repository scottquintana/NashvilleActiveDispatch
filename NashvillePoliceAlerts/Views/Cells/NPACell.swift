//
//  NPACell.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit

class NPACell: UITableViewCell {

    static let reuseID = "NPACell"
    
    let alertImage = UIImageView()
    let callTimeLabel = AlertBodyLabel(fontSize: 12)
    let incidentLabel = AlertTitleLabel(fontSize: 20)
    let addressLabel = AlertBodyLabel(fontSize: 14)
    
    var alertViewModel: ViewModel! {
        didSet {
            callTimeLabel.text = alertViewModel.callReceivedTime
            incidentLabel.text = alertViewModel.incident
            addressLabel.text = "Address: \(alertViewModel.streetAddress)"
        }
    }
    
    
    
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
        
        containerView.addSubview(callTimeLabel)
        callTimeLabel.textAlignment = .center
        
        containerView.addSubview(incidentLabel)
        alertImage.image = SFSymbols.bell
        alertImage.tintColor = Colors.accentGold
        alertImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerView.addSubview(alertImage)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
       // containerView.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .label
        
        let padding: CGFloat = 6
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            callTimeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            callTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            callTimeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            callTimeLabel.heightAnchor.constraint(equalToConstant: 14),
            
            incidentLabel.topAnchor.constraint(equalTo: callTimeLabel.bottomAnchor, constant: padding),
            incidentLabel.leadingAnchor.constraint(equalTo: alertImage.trailingAnchor, constant: 16),
            incidentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            incidentLabel.heightAnchor.constraint(equalToConstant: 22),
            
            alertImage.centerXAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            alertImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            alertImage.widthAnchor.constraint(equalToConstant: 40),
            alertImage.heightAnchor.constraint(equalToConstant: 40)
            
//            addressLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            addressLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            addressLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
//            addressLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
