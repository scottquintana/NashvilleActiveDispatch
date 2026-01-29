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
    
    let baseURL = "https://activedispatch-313918647466.us-east4.run.app/v1/city/nashville"
    
    func getAlerts(completed: @escaping (Result<[Place], ADError>) -> Void) {
        let endpoint = "get_alerts"

        guard let url = URL(string: baseURL) else {
            AnalyticsManager.shared.logAlertsFetchFailed(endpoint: endpoint)
            completed(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                AnalyticsManager.shared.logAlertsFetchFailed(
                    endpoint: endpoint,
                    error: error
                )
                completed(.failure(.invalidResponse))
                return
            }

            guard let http = response as? HTTPURLResponse else {
                AnalyticsManager.shared.logAlertsFetchFailed(endpoint: endpoint)
                completed(.failure(.invalidResponse))
                return
            }

            guard http.statusCode == 200 else {
                AnalyticsManager.shared.logAlertsFetchFailed(
                    endpoint: endpoint,
                    httpStatus: http.statusCode
                )
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                AnalyticsManager.shared.logAlertsFetchFailed(
                    endpoint: endpoint,
                    httpStatus: http.statusCode
                )
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601

                let payload = try decoder.decode(DispatchPayload.self, from: data)

                if payload.places.isEmpty {
                    AnalyticsManager.shared.logAlertsFetchEmpty(
                        endpoint: endpoint,
                        httpStatus: http.statusCode
                    )
                }

                completed(.success(payload.places))
            } catch {
                AnalyticsManager.shared.logAlertsFetchFailed(
                    endpoint: endpoint,
                    httpStatus: http.statusCode,
                    error: error
                )
                completed(.failure(.invalidData))
            }
        }

        task.resume()
    }
}
