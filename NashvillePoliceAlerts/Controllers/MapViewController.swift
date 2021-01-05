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
    
    var viewModel: ViewModel?
    
    var color1: CGColor {
        return viewModel?.incidentBadge.color.cgColor ?? Colors.gradientTop.cgColor
    }
    
    var gradientView: GradientView!
    
    let mapView = MKMapView()
    let addressLabel = AlertTitleLabel(fontSize: 18)
    let regionInMeters: Double = 2000

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        configureMap()
        
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
        
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.layer.cornerRadius = 24
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addressLabel.text = viewModel?.streetAddress ?? "No address"
        addressLabel.textAlignment = .center
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
        
            addressLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: padding),
            addressLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: 20),
            addressLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45),
            
        ])
    }
    

    private func configureMap() {
        

    }

    func addAnnotation(for location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        let center = location
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

}

