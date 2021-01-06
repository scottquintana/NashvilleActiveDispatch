//
//  MapViewController.swift
//  NashvilleActiveDispatch
//
//  Created by Scott Quintana on 1/3/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var viewModels: [ViewModel]!
    var selectedIndex: Int? {
        didSet {
            if selectedIndex != nil {
                self.updateMapFocus(incident: viewModels[selectedIndex!])
            }
        }
    }
    
    var selectedVM: ViewModel? {
        if selectedIndex != nil {
            return viewModels[selectedIndex!]
        } else { return nil }
    }
    
    var color1: CGColor!
    
    var gradientView: GradientView!
    let reuseID = "annotation"
    let mapView = MKMapView()
    let addressLabel = AlertTitleLabel(fontSize: 18)
    let regionInMeters: Double = 2000
    let leftArrowButton = UIButton()
    let rightArrowButton = UIButton()
    var allAnnotations: [ADPointAnnotation] = []
    
    var pinAnnotationView:MKPinAnnotationView!
    
    init(incidents: [ViewModel]){
        viewModels = incidents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        color1 = selectedVM?.incidentBadge.color.cgColor ?? Colors.gradientTop.cgColor
        configureUI()
        configureMap()
        loadIncidents()
        
    }
    
    private func configureUI() {
        view.layer.cornerRadius = 26
        gradientView = GradientView(cgColor1: color1, cgColor2: Colors.gradientBottom.cgColor)
        view.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        let path = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 30, height:  30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        gradientView.addSubview(mapView)
        gradientView.addSubview(addressLabel)
        
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabel.text = selectedVM?.streetAddress ?? ""
        addressLabel.textAlignment = .center
        
        leftArrowButton.setTitle("<<", for: .normal)
        
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        gradientView.addSubview(leftArrowButton)
        
        rightArrowButton.setTitle(">>", for: .normal)
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
        gradientView.addSubview(rightArrowButton)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -padding),
            mapView.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -padding),
            
            addressLabel.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45),
            
            leftArrowButton.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: padding),
            leftArrowButton.trailingAnchor.constraint(equalTo: addressLabel.leadingAnchor, constant: -padding),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 20),
            leftArrowButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45),
            
            rightArrowButton.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: padding),
            rightArrowButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -padding),
            rightArrowButton.heightAnchor.constraint(equalToConstant: 20),
            rightArrowButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45)
            
        ])
    }
    
    
    private func configureMap() {
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.layer.cornerRadius = 24
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseID)
    }
    
    private func loadIncidents() {
        for (index, incident) in viewModels.enumerated() {
            addAnnotation(for: incident, index: index)
        }
    }
    
    
    @objc private func leftArrowTapped() {
        if selectedIndex != nil {
            if selectedIndex == 0 {
                selectedIndex = viewModels.endIndex - 1
            } else {
                selectedIndex? -= 1
            }
        }
    }
    
    
    @objc private func rightArrowTapped() {
        if selectedIndex != nil {
            if selectedIndex == viewModels.count - 1 {
                selectedIndex = 0
            } else {
                selectedIndex? += 1
            }
        }
    }
    
    
    private func updateGradientColor(color: CGColor) {
        color1 = color
        configureUI()
    }
    
    
    private func addAnnotation(for location: ViewModel, index: Int) {
        let annotation = ADPointAnnotation()
        
        annotation.coordinate = location.incidentLocation
        annotation.title = location.incident
        annotation.index = index
        
        pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        allAnnotations.append(annotation)
        mapView.addAnnotation(pinAnnotationView.annotation!)
        
        
    }
    
    
    private func updateMapFocus(incident: ViewModel) {
        
        let center = incident.incidentLocation
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        addressLabel.text = incident.streetAddress
        updateGradientColor(color: incident.incidentBadge.color.cgColor)
    }
    
}

//MARK: - MapView Extensions

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation as? ADPointAnnotation else { return }
        selectedIndex = anno.index
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedIndex = nil
        configureUI()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let anno = annotation as? ADPointAnnotation else { return nil }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        let badgeInfo = viewModels[anno.index!].incidentBadge
        
        annotationView.markerTintColor = badgeInfo.color
        annotationView.glyphImage = badgeInfo.symbol
        annotationView.titleVisibility = .adaptive
        
        return annotationView
    }
}
