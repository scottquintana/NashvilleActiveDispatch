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
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            addressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addressLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addressLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
