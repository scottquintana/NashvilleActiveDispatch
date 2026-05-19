//
//  SettingsViewController.swift
//  Active Dispatch
//

import UIKit

final class SettingsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var recencyDebounceTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        configureTableView()
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = makeTitleHeader()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeTitleHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8)
        ])
        return header
    }
}

// MARK: - UITableViewDelegate / DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Feed"
        case 1: return "Time Window"
        case 2: return "City"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "Some cities include parking enforcement and administrative data in their dispatch feed. This is hidden by default."
        case 1: return "Incidents older than the selected time will be hidden."
        case 2: return "Incident data is provided directly by each city's public dispatch feed. Active Dispatch only displays what each city reports and is not responsible for the accuracy, completeness, or timeliness of that data."
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 80 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.backgroundColor = .secondarySystemGroupedBackground

        let textColor = UIColor.label

        switch indexPath.section {
        case 0:
            var config = cell.defaultContentConfiguration()
            config.text = "Show all incident types"
            config.textProperties.color = textColor
            config.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
            config.imageProperties.tintColor = textColor
            cell.contentConfiguration = config
            let toggle = UISwitch()
            toggle.isOn = FilterManager.shared.showAllIncidentTypes
            toggle.onTintColor = CityManager.shared.currentTheme.buttonColor
            toggle.addTarget(self, action: #selector(filterToggleChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none

        case 1:
            cell.selectionStyle = .none
            cell.accessoryView = nil

            if cell.contentView.viewWithTag(700) == nil {
                let iconView = UIImageView(image: UIImage(systemName: "clock"))
                iconView.tintColor = textColor
                iconView.contentMode = .scaleAspectFit
                iconView.translatesAutoresizingMaskIntoConstraints = false
                iconView.tag = 700

                let titleLabel = UILabel()
                titleLabel.text = "Time Window"
                titleLabel.font = .systemFont(ofSize: 17)
                titleLabel.textColor = textColor
                titleLabel.translatesAutoresizingMaskIntoConstraints = false

                let valueLabel = UILabel()
                valueLabel.font = .systemFont(ofSize: 14)
                valueLabel.textColor = .secondaryLabel
                valueLabel.textAlignment = .right
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.tag = 702

                let slider = UISlider()
                slider.minimumValue = 1
                slider.maximumValue = Float(FilterManager.maxAgeUnlimited)
                slider.tintColor = CityManager.shared.currentTheme.buttonColor
                slider.addTarget(self, action: #selector(recencySliderChanged(_:)), for: .valueChanged)
                slider.translatesAutoresizingMaskIntoConstraints = false
                slider.tag = 703

                cell.contentView.addSubview(iconView)
                cell.contentView.addSubview(titleLabel)
                cell.contentView.addSubview(valueLabel)
                cell.contentView.addSubview(slider)

                NSLayoutConstraint.activate([
                    iconView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    iconView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
                    iconView.widthAnchor.constraint(equalToConstant: 22),
                    iconView.heightAnchor.constraint(equalToConstant: 22),

                    titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
                    titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

                    valueLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    valueLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
                    valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),

                    slider.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
                    slider.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                    slider.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    slider.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12),
                ])
            }

            if let valueLabel = cell.contentView.viewWithTag(702) as? UILabel {
                valueLabel.text = FilterManager.shared.recencyLabel
            }
            if let slider = cell.contentView.viewWithTag(703) as? UISlider {
                slider.value = Float(FilterManager.shared.maxAgeHours)
            }

        case 2:
            var config = cell.defaultContentConfiguration()
            config.text = "Change City"
            config.textProperties.color = textColor
            config.image = UIImage(systemName: "building.2")
            config.imageProperties.tintColor = textColor
            cell.contentConfiguration = config
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 { showCitySelection() }
    }

    @objc private func filterToggleChanged(_ sender: UISwitch) {
        FilterManager.shared.showAllIncidentTypes = sender.isOn
    }

    @objc private func recencySliderChanged(_ sender: UISlider) {
        let hours = Int(sender.value.rounded())
        sender.value = Float(hours)

        // Update label immediately so it feels responsive
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
           let label = cell.contentView.viewWithTag(702) as? UILabel {
            label.text = hours >= FilterManager.maxAgeUnlimited
                ? "All incidents (12+ hours)"
                : "Last \(hours) hour\(hours == 1 ? "" : "s")"
        }

        // Debounce the filter + notification so the feed only recomputes after dragging stops
        recencyDebounceTimer?.invalidate()
        recencyDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            guard self != nil else { return }
            FilterManager.shared.maxAgeHours = hours
        }
    }

    private func showCitySelection() {
        let citySelectionVC = CitySelectionViewController()
        citySelectionVC.onCitySelected = { [weak self] city in
            self?.dismissToRoot(with: city)
        }
        citySelectionVC.modalPresentationStyle = .fullScreen
        present(citySelectionVC, animated: true)
    }

    private func dismissToRoot(with city: City) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?
            .delegate as? SceneDelegate else { return }
        sceneDelegate.switchToCity(city)
    }
}
