//
//  RecognizeHTTP.swift
//  Bagirata
//
//  Created by Frederich Blessy on 03/07/24.
//

import Foundation

func recognize(model: String, completion: @escaping (Result<ItemResponse, Error>) -> Void) {
    let endpoint = "http://192.168.18.50:8080/v1/recognize"
    guard let url = URL(string: endpoint) else {
        completion(.failure(HTTPError.invalidURL))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: AnyHashable] = [
        "model": model
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            completion(.failure(error ??  HTTPError.invalidData))
            return
        }
        
        do {
            let response = try JSONDecoder().decode(ItemResponse.self, from: data)
            completion(.success(response))
        }
        catch {
            completion(.failure(HTTPError.invalidResponse))
        }
    }
    
    task.resume()
}

enum HTTPError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
