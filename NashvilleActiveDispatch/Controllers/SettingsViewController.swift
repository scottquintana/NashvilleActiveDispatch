//
//  SettingsViewController.swift
//  Active Dispatch
//

import UIKit

final class SettingsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = CityManager.shared.currentTheme.background
        configureTableView()
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate / DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Feed"
        case 1: return "City"
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        return "Some cities include parking enforcement and administrative data in their dispatch feed. This is hidden by default."
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.backgroundColor = CityManager.shared.currentTheme.gradientTop

        let textColor = CityManager.shared.currentTheme.detailText

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
            toggle.addTarget(self, action: #selector(filterToggleChanged(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none
        case 1:
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
        if indexPath.section == 1 { showCitySelection() }
    }

    @objc private func filterToggleChanged(_ sender: UISwitch) {
        FilterManager.shared.showAllIncidentTypes = sender.isOn
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
