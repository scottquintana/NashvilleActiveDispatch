//
//  NetworkManager.swift
//  Active Dispatch
//
//  Created by Scott Quintana on 12/29/20.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}  
    
    let baseURL = "https://data.nashville.gov/resource/qywv-8sc2.json"
    
    func getAlerts(completed: @escaping (Result<[IncidentData], ADError>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.invalidURL))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let alerts = try decoder.decode([IncidentData].self, from: data)
                completed(.success(alerts))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
