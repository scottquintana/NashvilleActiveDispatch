//
//  ADCell.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit
import CoreLocation

class ADCell: UITableViewCell {

    static let reuseID = "ADCell"
    
    let alertImage = UIImageView()
    let callTimeLabel = AlertBodyLabel(fontSize: 12)
    let incidentLabel = AlertTitleLabel(fontSize: 18)
    let locationLabel = AlertBodyLabel(fontSize: 14)
    var currentLocation: CLLocation! {
        return LocationManager.shared.currentLocation
    }
    
    var distanceAway: String? {
        guard let distanceInMeters = currentLocation?.distance(from: alertViewModel.incidentLocation) else { return "" }
        let distance = Measurement(value: distanceInMeters, unit: UnitLength.meters)
        let miles = distance.converted(to: .miles)
        let milesString = String(format: "%.1f", miles.value)
        return "\(alertViewModel.neighborhood) - \(milesString) mi. away"
    }
    
    var alertViewModel: IncidentViewModel! {
        didSet {
            callTimeLabel.text = alertViewModel.timeSinceCall
            incidentLabel.text = alertViewModel.incidentDescription
            if currentLocation == nil {
                locationLabel.text = "Calculating distance..."
            } else { locationLabel.text = distanceAway }
            alertImage.image = alertViewModel.incidentBadge.symbol
            alertImage.tintColor = alertViewModel.incidentBadge.color
        }
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let containerView = GradientView()
        contentView.addSubview(containerView)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubviews(callTimeLabel, incidentLabel, alertImage, locationLabel)
        callTimeLabel.textAlignment = .center
        alertImage.translatesAutoresizingMaskIntoConstraints = false
        
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
            incidentLabel.heightAnchor.constraint(equalToConstant: 20),
            
            alertImage.centerXAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            alertImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            alertImage.widthAnchor.constraint(equalToConstant: 40),
            alertImage.heightAnchor.constraint(equalToConstant: 40),
            
            locationLabel.topAnchor.constraint(equalTo: incidentLabel.bottomAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: alertImage.trailingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            locationLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}
