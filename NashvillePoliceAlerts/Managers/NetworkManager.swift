//
//  NetworkManager.swift
//  NashvillePoliceAlerts
//
//  Created by Scott Quintana on 12/29/20.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}  
    
    let baseURL = "https://data.nashville.gov/resource/qywv-8sc2.json"
    
    func getAlerts(completed: @escaping (Result<[NPAData], Error>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                print("task error")
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("response error")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let alerts = try decoder.decode([NPAData].self, from: data)
                completed(.success(alerts))
            } catch {
                print("decoding error")
            }
        }
        task.resume()
    }
}
