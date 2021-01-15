//
//  ViewController.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let imageView = UIImageView()
    private var pullControl = UIRefreshControl()
    
    let locationManager = LocationManager()
    
    let mapButton = ADMapButton()
    var alertViewModels = [IncidentViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Active Dispatch"
        locationManager.delegate = self
        view.backgroundColor = Colors.backgroundBlue
    
        configureTableView()
        configureHeaderImage()
        configureMapButton()
        loadAlerts()
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.rowHeight = 100
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ADCell.self, forCellReuseIdentifier: ADCell.reuseID)
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        tableView.refreshControl = pullControl
    }
    
        
    private func configureHeaderImage() {
        let image = UIImage(named: "nashvilleHeader")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        view.addSubview(imageView)
    }
    
    
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
    
    
    private func loadAlerts() {
        NetworkManager.shared.getAlerts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let alerts):
                self.alertViewModels = alerts.map({ return IncidentViewModel(alert: $0)})
                
                self.alertViewModels.sort { (vm, vm2) -> Bool in
                    vm.callReceivedTime > vm2.callReceivedTime
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.presentADAlertOnMainThread(title: "Networking error.", message: error.rawValue, buttonTitle: "Ok.")
            }
        }
    }
    
    
    @objc private func refreshTableView(_ sender: Any) {
        loadAlerts()
        pullControl.endRefreshing()
        
    }
    
    
    @objc private func viewAllOnMap() {
        let mapVC = MapViewController(incidents: alertViewModels)
        present(mapVC, animated: true)
    }
}

//MARK: - TableView Extensions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ADCell.reuseID) as! ADCell
        let alert = alertViewModels[indexPath.row]
        cell.alertViewModel = alert
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapVC = MapViewController(incidents: alertViewModels)
        mapVC.selectedIndex = indexPath.row

        present(mapVC, animated: true)
    }
    
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = max(y, 85)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}

extension ViewController: LocationManagerDelegate {
    func didUpdateCurrentLocation() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
}
