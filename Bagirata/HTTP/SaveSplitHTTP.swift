//
//  SaveSplitHTTP.swift
//  Bagirata
//
//  Created by Frederich Blessy on 10/07/24.
//

import Foundation

func saveSplit(payload: Splitted, completion: @escaping (Result<SaveSplitResponse, Error>) -> Void) {
    let endpoint = "https://bagirata.co/v1/splits"
    guard let url = URL(string: endpoint) else {
        completion(.failure(HTTPError.invalidURL))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let body = try JSONEncoder().encode(payload)
        
        if let jsonString = String(data: body, encoding: .utf8) {
            print(jsonString)
        } else {
            print("Failed to convert JSON data to string.")
        }
        
        request.httpBody = body
    } catch {
        completion(.failure(error))
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            completion(.failure(error ??  HTTPError.invalidData))
            return
        }
        
        do {
            let response = try JSONDecoder().decode(SaveSplitResponse.self, from: data)
            completion(.success(response))
        }
        catch {
            completion(.failure(HTTPError.invalidResponse))
        }
    }
    
    task.resume()
}
