//
//  MapViewController.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 1/3/21.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {

    // MARK: - Inputs / State

    private let viewModels: [IncidentViewModel]

    var selectedIndex: Int? {
        didSet {
            guard isViewLoaded else { return }
            if let idx = selectedIndex, viewModels.indices.contains(idx) {
                updateMapFocus(incident: viewModels[idx])
            } else {
                updateMapFocus(incident: nil)
            }
        }
    }

    private var selectedVM: IncidentViewModel? {
        guard let idx = selectedIndex, viewModels.indices.contains(idx) else { return nil }
        return viewModels[idx]
    }

    private let reuseID = "annotation"
    private let regionInMeters: Double = 2000

    private var allAnnotations: [ADPointAnnotation] = []
    private var didAddAnnotations = false

    // MARK: - UI

    private var gradientView: GradientView!
    private let mapView = MKMapView()
    private let mapNavigationView = MapNavigationView()
    private let closeButton = ADCloseButton()

    // MARK: - Init

    init(incidents: [IncidentViewModel]) {
        self.viewModels = incidents
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapNavigationView.delegate = self

        configureUI()
        configureButtons()
        configureMap()

        // Defer expensive map work until after presentation has a chance to complete.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.loadIncidentsIfNeeded()

            if self.selectedIndex == nil {
                self.updateMapFocus(incident: nil)
            } else if let idx = self.selectedIndex, self.viewModels.indices.contains(idx) {
                self.updateMapFocus(incident: self.viewModels[idx])
            }

            if self.viewModels.isEmpty {
                self.presentADAlertOnMainThread(
                    title: "Alert.",
                    message: "There are no active incidents!",
                    buttonTitle: "Ok."
                )
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topRight, .topLeft],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }

    // MARK: - UI Setup

    private func configureUI() {
        let topColor = selectedVM?.incidentBadge.color.cgColor ?? Colors.gradientTop.cgColor
        gradientView = GradientView(cgColor1: topColor, cgColor2: Colors.gradientBottom.cgColor)
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        view.layer.cornerRadius = 26
        view.clipsToBounds = true

        view.addSubviews(gradientView, closeButton, mapView, mapNavigationView)

        let padding: CGFloat = 10

        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapNavigationView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: padding),
            closeButton.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 110),
            closeButton.heightAnchor.constraint(equalToConstant: 20),

            mapView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding),
            mapView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -padding),
            mapView.bottomAnchor.constraint(equalTo: mapNavigationView.topAnchor, constant: -padding),

            mapNavigationView.heightAnchor.constraint(equalToConstant: 41),
            mapNavigationView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            mapNavigationView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor),
            mapNavigationView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45)
        ])
    }

    private func configureButtons() {
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

    private func configureMap() {
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.layer.cornerRadius = 24
        mapView.delegate = self

        // Optional: delay user location to avoid first-frame hitch
        mapView.showsUserLocation = false
        DispatchQueue.main.async { [weak self] in
            self?.mapView.showsUserLocation = true
        }

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseID)
    }

    // MARK: - Data -> Map

    private func loadIncidentsIfNeeded() {
        guard !didAddAnnotations else { return }
        didAddAnnotations = true

        allAnnotations = viewModels.enumerated().map { index, incident in
            let annotation = ADPointAnnotation()
            annotation.coordinate = incident.incidentLocation.coordinate
            annotation.title = incident.incidentDescription
            annotation.index = index
            return annotation
        }

        mapView.addAnnotations(allAnnotations)
    }

    private func updateGradientColor(_ color: CGColor) {
        gradientView.updateColor(newTop: color)
    }

    private func updateMapFocus(incident: IncidentViewModel?) {
        if let incident = incident {
            let center = incident.incidentLocation.coordinate
            let region = MKCoordinateRegion(
                center: center,
                latitudinalMeters: regionInMeters,
                longitudinalMeters: regionInMeters
            )
            mapView.setRegion(region, animated: true)
            updateLabels()

            updateGradientColor(incident.incidentBadge.color.cgColor)
        } else {
            // If we haven't loaded annotations yet, do nothing; focus will happen once they're added.
            guard !allAnnotations.isEmpty else { return }
            mapView.showAnnotations(allAnnotations, animated: true)
            updateLabels()
            updateGradientColor(selectedVM?.incidentBadge.color.cgColor ?? Colors.gradientTop.cgColor)
        }
    }

    private func updateLabels() {
        mapNavigationView.set(address: selectedVM?.streetAddress, time: selectedVM?.callReceivedTime)
    }

    // MARK: - Actions

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation as? ADPointAnnotation else { return }
        selectedIndex = anno.index
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedIndex = nil
        updateLabels()
        updateGradientColor(Colors.gradientTop.cgColor)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Let MapKit keep the blue dot
        if annotation is MKUserLocation { return nil }

        guard let anno = annotation as? ADPointAnnotation,
              let idx = anno.index,
              viewModels.indices.contains(idx) else { return nil }

        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID, for: annotation) as! MKMarkerAnnotationView

        let badgeInfo = viewModels[idx].incidentBadge

        annotationView.annotation = annotation

        if badgeInfo.color == Colors.accentRed {
            annotationView.displayPriority = .required
        } else {
            annotationView.displayPriority = .defaultLow
        }

        annotationView.markerTintColor = badgeInfo.color
        annotationView.glyphImage = badgeInfo.symbol
        annotationView.titleVisibility = .adaptive

        return annotationView
    }
}

// MARK: - MapNavigationViewDelegate

extension MapViewController: MapNavigationViewDelegate {

    func didPressArrowButton(direction: ArrowDirection) {
        switch direction {
        case .left:
            leftArrowTapped()
        case .right:
            rightArrowTapped()
        }
    }

    private func leftArrowTapped() {
        guard !viewModels.isEmpty else { return }

        if let idx = selectedIndex {
            selectedIndex = (idx == 0) ? (viewModels.count - 1) : (idx - 1)
        } else {
            selectedIndex = 0
        }
    }

    private func rightArrowTapped() {
        guard !viewModels.isEmpty else { return }

        if let idx = selectedIndex {
            selectedIndex = (idx == viewModels.count - 1) ? 0 : (idx + 1)
        } else {
            selectedIndex = 0
        }
    }
}
