//
//  ViewController.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let imageView = UIImageView()
    private var pullControl = UIRefreshControl()
    private var currentAlerts: [NPAData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nashville Crime Alerts"

        configureTableView()
        configureHeaderImage()
        loadAlerts()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.bounds
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NPACell.self, forCellReuseIdentifier: NPACell.reuseID)
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        tableView.refreshControl = pullControl
        
    }
        
    private func configureHeaderImage() {
        let image = UIImage(named: "nashville")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.5
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        view.addSubview(imageView)
    }
    
    
    private func loadAlerts() {
        NetworkManager.shared.getAlerts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let alerts):
                print("success")
                self.currentAlerts = alerts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @objc private func refreshTableView(_ sender: Any) {
        loadAlerts()
        pullControl.endRefreshing()
    }
    
    
    
}

//MARK: - TableView Extensions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAlerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NPACell.reuseID) as! NPACell
        cell.set(alert: currentAlerts[indexPath.row])
        return cell
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y
        let height = max(y, 85)
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}
