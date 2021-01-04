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
    
    let locationManager = CLLocationManager()
    let mapView = MKMapView()
    
    let regionInMeters: Double = 9000

    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView = GradientView(cgColor1: color1, cgColor2: Colors.gradientBottom.cgColor)
        view.layer.cornerRadius = 26
        configureUI()
        configureMap()
        checkLocationServices()
        
       
    }
    
    private func configureUI() {
        view.addSubview(gradientView)
        
        let path = UIBezierPath(roundedRect:view.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 30, height:  30))
        let maskLayer = CAShapeLayer()

        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    

    private func configureMap() {
        gradientView.addSubview(mapView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.isRotateEnabled = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.layer.cornerRadius = 24
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 6
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 30),
            mapView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -padding),
            mapView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -45)
        ])
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
    
        } else {
            // error
        }
    }
    
    private func centerViewOnLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnLocation()
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
