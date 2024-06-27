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
    
    let baseURL = "https://services2.arcgis.com/HdTo6HJqh92wn4D8/arcgis/rest/services/Metro_Nashville_Police_Department_Active_Dispatch_Table_view/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson"
    
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
                let payload = try decoder.decode(DispatchPayload.self, from: data)
                let alerts = payload.features.map { $0.properties }
                completed(.success(alerts))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
