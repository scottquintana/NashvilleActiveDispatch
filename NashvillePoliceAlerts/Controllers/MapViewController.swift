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
    
    var viewModels: [IncidentViewModel]!
    var selectedIndex: Int? {
        didSet {
            if selectedIndex != nil {
                self.updateMapFocus(incident: viewModels[selectedIndex!])
            }
        }
    }
    
    var selectedVM: IncidentViewModel? {
        if selectedIndex != nil {
            return viewModels[selectedIndex!]
        } else { return nil }
    }
    
    var color1: CGColor!
    let reuseID = "annotation"
    let regionInMeters: Double = 2000
    var allAnnotations: [ADPointAnnotation] = []
    
    var gradientView: GradientView!
    let mapView = MKMapView()
    var pinAnnotationView:MKPinAnnotationView!
    
    let closeButton = ADCloseButton()
    let leftArrowButton = ADArrowButton(direction: .left)
    let rightArrowButton = ADArrowButton(direction: .right)
    let addressLabel = AlertTitleLabel(fontSize: 18)

   
    init(incidents: [IncidentViewModel]){
        viewModels = incidents
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureButtons()
        configureMap()
        configureLabels()
        loadIncidents()
        
        if selectedIndex == nil {
            updateMapFocus(incident: nil)
        }
   }

    
    private func configureUI() {
        color1 = selectedVM?.incidentBadge.color.cgColor ?? Colors.gradientTop.cgColor
        gradientView = GradientView(cgColor1: color1, cgColor2: Colors.gradientBottom.cgColor)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        let path = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 30, height:  30))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        view.layer.mask = maskLayer
        view.layer.cornerRadius = 26
        view.addSubviews(gradientView, leftArrowButton, rightArrowButton, closeButton, mapView, addressLabel)
        
        let padding: CGFloat = 10
        
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
            mapView.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -padding),
            
            addressLabel.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45),
            
            leftArrowButton.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 20),
            leftArrowButton.widthAnchor.constraint(equalToConstant: 24),
            leftArrowButton.heightAnchor.constraint(equalToConstant: 24),
            leftArrowButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45),
            
            rightArrowButton.heightAnchor.constraint(equalToConstant: 24),
            rightArrowButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -20),
            rightArrowButton.widthAnchor.constraint(equalToConstant: 24),
            rightArrowButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45)
       ])
    }
    
    
    private func configureButtons() {
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
        leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        
        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
        rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
       
    }
    
    
    private func configureMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.layer.cornerRadius = 24
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: reuseID)
    }
    
    
    private func configureLabels() {
        addressLabel.text = selectedVM?.streetAddress ?? ""
        addressLabel.textAlignment = .center
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
        } else {
            selectedIndex = 0
        }
    }
    
    
    @objc private func rightArrowTapped() {
        if selectedIndex != nil {
            if selectedIndex == viewModels.count - 1 {
                selectedIndex = 0
            } else {
                selectedIndex? += 1
            }
        } else {
            selectedIndex = 0
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    
    private func updateGradientColor(color: CGColor) {
        color1 = color
        configureUI()
    }
    
    
    private func addAnnotation(for location: IncidentViewModel, index: Int) {
        let annotation = ADPointAnnotation()
        
        annotation.coordinate = location.incidentLocation
        annotation.title = location.incidentDescription
        annotation.index = index
        
        pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        allAnnotations.append(annotation)
        mapView.addAnnotation(pinAnnotationView.annotation!)
        
        
    }
    
    
    private func updateMapFocus(incident: IncidentViewModel?) {
        if let incident = incident {
            let center = incident.incidentLocation
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            addressLabel.text = incident.streetAddress
            updateGradientColor(color: incident.incidentBadge.color.cgColor)
        } else {
            mapView.showAnnotations(allAnnotations, animated: true)
        }
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
        configureLabels()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let anno = annotation as? ADPointAnnotation else { return nil }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        let badgeInfo = viewModels[anno.index!].incidentBadge
        
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
