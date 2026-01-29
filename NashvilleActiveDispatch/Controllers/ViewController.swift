//
//  ViewController.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit
import Combine
import CoreLocation

enum SortOption: Int, CaseIterable {
    case timeNewest = 0
    case timeOldest = 1
    case distanceNearest = 2
    case distanceFarthest = 3

    var displayText: String {
        switch self {
        case .timeNewest: return "Time"
        case .timeOldest: return "Time"
        case .distanceNearest: return "Distance"
        case .distanceFarthest: return "Distance"
        }
    }

    var triangleDirection: String {
        switch self {
        case .timeNewest, .distanceNearest: return "▼"
        case .timeOldest, .distanceFarthest: return "▲"
        }
    }

    func next() -> SortOption {
        let allCases = SortOption.allCases
        let currentIndex = allCases.firstIndex(of: self) ?? 0
        let nextIndex = (currentIndex + 1) % allCases.count
        return allCases[nextIndex]
    }
}

final class ViewController: UIViewController {

    private let tableView = UITableView()
    private var pullControl = UIRefreshControl()
    private let sortButton = UIButton(type: .system)

    private let headerContainerView = UIView()
    private let imageView = UIImageView()
    private let largeTitleLabel = UILabel()

    private let headerHeight: CGFloat = 200
    private let headerBaseImageAlpha: CGFloat = 0.5

    // MARK: - Loading / Empty state overlay

    private let stateOverlayView = UIView()
    private let stateSpinner = UIActivityIndicatorView(style: .large)
    private let stateLabel = UILabel()

    let locationManager = LocationManager()
    let mapButton = ADMapButton()

    var alertViewModels = [IncidentViewModel]()
    var currentSort: SortOption = .timeNewest

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        view.backgroundColor = Colors.backgroundBlue

        configureNavigationBarForCustomLargeTitle()
        configureTableView()
        configureHeader()
        configureSortButton()
        configureMapButton()
        configureStateOverlay()

        showLoadingState(text: "Loading incidents…")
        loadAlerts()

        // Ensure initial header state is applied (no snapping)
        updateHeader(for: tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = view.bounds.width
        headerContainerView.frame = CGRect(x: 0, y: 0, width: width, height: headerHeight)
        imageView.frame = headerContainerView.bounds

        let leftInset: CGFloat = 16
        let bottomInset: CGFloat = 10
        let labelHeight: CGFloat = 48
        largeTitleLabel.frame = CGRect(
            x: leftInset,
            y: headerHeight - labelHeight - bottomInset,
            width: width - (leftInset * 2),
            height: labelHeight
        )

        // Re-assign to force UITableView to respect updated header sizing.
        tableView.tableHeaderView = headerContainerView

        updateHeader(for: tableView)
    }

    // MARK: - Nav Bar (custom large title)

    private func configureNavigationBarForCustomLargeTitle() {
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false

        guard let navBar = navigationController?.navigationBar else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance

        navBar.tintColor = .white
        navBar.isTranslucent = true
    }

    // MARK: - Table

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ADCell.self, forCellReuseIdentifier: ADCell.reuseID)

        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = pullControl
    }

    // MARK: - Header (tableHeaderView)

    private func configureHeader() {
        headerContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight)
        headerContainerView.clipsToBounds = true
        headerContainerView.backgroundColor = .clear

        imageView.image = UIImage(named: "nashvilleHeader")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = headerBaseImageAlpha
        imageView.frame = headerContainerView.bounds

        largeTitleLabel.text = "Active Dispatch"
        largeTitleLabel.textColor = .white
        largeTitleLabel.alpha = 1.0
        largeTitleLabel.numberOfLines = 1
        largeTitleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)

        headerContainerView.addSubview(imageView)
        headerContainerView.addSubview(largeTitleLabel)

        tableView.tableHeaderView = headerContainerView
    }

    private func updateHeader(for scrollView: UIScrollView) {
        let y = max(0, scrollView.contentOffset.y)

        let fadeDistance: CGFloat = 120
        let t = min(1, y / fadeDistance)

        imageView.alpha = headerBaseImageAlpha * (1 - t)
        largeTitleLabel.alpha = 1 - t
        largeTitleLabel.transform = CGAffineTransform(translationX: 0, y: -10 * t)

        navigationItem.title = (t >= 1.0) ? "Active Dispatch" : ""
    }

    // MARK: - Loading / Empty overlay

    private func configureStateOverlay() {
        stateOverlayView.translatesAutoresizingMaskIntoConstraints = false
        stateOverlayView.backgroundColor = .clear
        stateOverlayView.isHidden = true
        view.addSubview(stateOverlayView)

        stateSpinner.translatesAutoresizingMaskIntoConstraints = false
        stateSpinner.hidesWhenStopped = true

        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.textColor = .white
        stateLabel.numberOfLines = 0
        stateLabel.textAlignment = .center
        stateLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        stateOverlayView.addSubview(stateSpinner)
        stateOverlayView.addSubview(stateLabel)

        NSLayoutConstraint.activate([
            // Center in the visible content area
            stateOverlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateOverlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stateOverlayView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            stateOverlayView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            stateSpinner.centerXAnchor.constraint(equalTo: stateOverlayView.centerXAnchor),
            stateSpinner.topAnchor.constraint(equalTo: stateOverlayView.topAnchor),

            stateLabel.topAnchor.constraint(equalTo: stateSpinner.bottomAnchor, constant: 12),
            stateLabel.leadingAnchor.constraint(equalTo: stateOverlayView.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: stateOverlayView.trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: stateOverlayView.bottomAnchor)
        ])
    }

    private func showLoadingState(text: String) {
        stateOverlayView.isHidden = false
        stateLabel.text = text
        stateSpinner.startAnimating()
    }

    private func showEmptyState(text: String) {
        stateOverlayView.isHidden = false
        stateLabel.text = text
        stateSpinner.stopAnimating()
    }

    private func hideStateOverlay() {
        stateSpinner.stopAnimating()
        stateOverlayView.isHidden = true
    }

    // MARK: - Sort Button

    private func configureSortButton() {
        sortButton.setTitleColor(.white, for: .normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

        updateSortButton()

        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 95),
            sortButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        let buttonItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = buttonItem
    }

    private func updateSortButton() {
        let text = "\(currentSort.displayText) \(currentSort.triangleDirection)"
        sortButton.setTitle(text, for: .normal)
    }

    // MARK: - Map Button

    private func configureMapButton() {
        mapButton.frame = CGRect(x: view.frame.width - 80, y: view.frame.height - 120, width: 60, height: 60)
        mapButton.layer.cornerRadius = mapButton.bounds.size.width / 2
        mapButton.clipsToBounds = true
        mapButton.layer.masksToBounds = false
        mapButton.layer.shadowRadius = 5
        mapButton.layer.shadowOpacity = 0.4
        mapButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        mapButton.layer.shadowColor = UIColor.black.cgColor

        mapButton.addTarget(self, action: #selector(viewAllOnMap), for: .touchUpInside)
        view.addSubview(mapButton)
    }

    // MARK: - Data

    private func loadAlerts() {
        NetworkManager.shared.getAlerts { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let alerts):
                self.alertViewModels = alerts.map { IncidentViewModel(alert: $0) }
                self.sortAlerts()

                DispatchQueue.main.async {
                    self.tableView.reloadData()

                    if self.alertViewModels.isEmpty {
                        self.showEmptyState(text: "No active incidents.")
                    } else {
                        self.hideStateOverlay()
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideStateOverlay()
                    self.presentADAlertOnMainThread(
                        title: "Networking error.",
                        message: error.rawValue,
                        buttonTitle: "Ok."
                    )
                }
            }
        }
    }

    private func sortAlerts() {
        switch currentSort {
        case .timeNewest:
            alertViewModels.sort { vm1, vm2 in
                let date1 = DateHelper.convertISO8601ToDate(vm1.alertData.callTimeReceived)
                let date2 = DateHelper.convertISO8601ToDate(vm2.alertData.callTimeReceived)
                return date1 > date2
            }

        case .timeOldest:
            alertViewModels.sort { vm1, vm2 in
                let date1 = DateHelper.convertISO8601ToDate(vm1.alertData.callTimeReceived)
                let date2 = DateHelper.convertISO8601ToDate(vm2.alertData.callTimeReceived)
                return date1 < date2
            }

        case .distanceNearest:
            guard let userLocation = locationManager.currentLocation else {
                currentSort = .timeNewest
                updateSortButton()
                sortAlerts()
                return
            }
            alertViewModels.sort { vm1, vm2 in
                let distance1 = userLocation.distance(from: vm1.incidentLocation)
                let distance2 = userLocation.distance(from: vm2.incidentLocation)
                return distance1 < distance2
            }

        case .distanceFarthest:
            guard let userLocation = locationManager.currentLocation else {
                currentSort = .timeNewest
                updateSortButton()
                sortAlerts()
                return
            }
            alertViewModels.sort { vm1, vm2 in
                let distance1 = userLocation.distance(from: vm1.incidentLocation)
                let distance2 = userLocation.distance(from: vm2.incidentLocation)
                return distance1 > distance2
            }
        }
    }

    // MARK: - Actions

    @objc private func refreshTableView(_ sender: Any) {
        AnalyticsManager.shared.logRefreshTriggered(endpoint: "get_alerts")
        showLoadingState(text: "Refreshing…")

        NetworkManager.shared.getAlerts { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let alerts):
                AnalyticsManager.shared.logRefreshSucceeded(endpoint: "get_alerts", httpStatus: 200)

                self.alertViewModels = alerts.map { IncidentViewModel(alert: $0) }
                self.sortAlerts()

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.pullControl.endRefreshing()

                    if self.alertViewModels.isEmpty {
                        self.showEmptyState(text: "No active incidents.")
                    } else {
                        self.hideStateOverlay()
                    }
                }

            case .failure:
                AnalyticsManager.shared.logRefreshFailed(endpoint: "get_alerts", error: nil)

                DispatchQueue.main.async {
                    self.pullControl.endRefreshing()
                    // Keep previous content; show a lightweight message instead of nuking the list.
                    self.hideStateOverlay()
                }
            }
        }
    }

    @objc private func sortButtonTapped() {
        currentSort = currentSort.next()
        AnalyticsManager.shared.logSortChanged(option: currentSort)
        updateSortButton()
        sortAlerts()
        tableView.reloadData()
    }

    @objc private func viewAllOnMap() {
        AnalyticsManager.shared.logMapOpened(source: .button)
        let mapVC = MapViewController(incidents: alertViewModels)
        present(mapVC, animated: true)
    }
}

// MARK: - UITableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alertViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ADCell.reuseID) as! ADCell
        cell.alertViewModel = alertViewModels[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = alertViewModels[indexPath.row]

        if let distanceMiles = DistanceCalculator.distanceInMiles(
            from: locationManager.currentLocation,
            to: alert.incidentLocation
        ) {
            AnalyticsManager.shared.logIncidentTapped(
                incidentType: alert.incidentDescription,
                neighborhood: alert.neighborhood,
                distanceMiles: distanceMiles
            )
        }

        AnalyticsManager.shared.logMapOpened(source: .tap)

        let mapVC = MapViewController(incidents: alertViewModels)
        mapVC.selectedIndex = indexPath.row
        present(mapVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeader(for: scrollView)
    }
}

// MARK: - LocationManagerDelegate

extension ViewController: LocationManagerDelegate {
    func didUpdateCurrentLocation() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
