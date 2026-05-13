//
//  CityCell.swift
//  Active Dispatch
//

import UIKit

final class CityCell: UITableViewCell {

    static let reuseID = "CityCell"

    private let gradientView = GradientView()
    private let nameLabel = UILabel()
    private let chevronImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(city: City) {
        nameLabel.text = city.displayName
        gradientView.updateColors(
            top: city.theme.gradientTop.cgColor,
            bottom: city.theme.gradientBottom.cgColor
        )
    }

    private func configure() {
        backgroundColor = .clear
        selectionStyle = .none

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 20
        gradientView.clipsToBounds = true
        contentView.addSubview(gradientView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        gradientView.addSubview(nameLabel)

        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        chevronImage.image = UIImage(systemName: "chevron.right")
        chevronImage.tintColor = UIColor.white.withAlphaComponent(0.6)
        chevronImage.contentMode = .scaleAspectFit
        gradientView.addSubview(chevronImage)

        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            nameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 24),
            nameLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor, constant: -12),

            chevronImage.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -24),
            chevronImage.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            chevronImage.widthAnchor.constraint(equalToConstant: 14),
            chevronImage.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
