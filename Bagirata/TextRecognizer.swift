//
//  TextRecognizer.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import Foundation
import Vision
import VisionKit

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
    
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    
    private let queue = DispatchQueue(label: "scan-codes", qos: .default, attributes: [],autoreleaseFrequency: .workItem)
    
    func recognizeText(withCompletionHandler completionHandler:@escaping (ItemSplit) -> Void) {
        queue.async {
            let images = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at: $0).cgImage
            })
            
            let imagesAndRequests = images.map({(images: $0, request: VNRecognizeTextRequest())})
            let texts = imagesAndRequests.map{image, request->[String] in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                
                do {
                    try handler.perform([request])
                    guard let observations = request.results else { return [] }
                    return observations.compactMap({$0.topCandidates(1).first?.string})
                } catch {
                    print(error)
                    return []
                }
            }
            
            
            DispatchQueue.main.sync {
                for text in texts {
                    print(text)
                    recognize(model: text.joined(separator: " ")) { result in
                        switch result {
                        case .success(let response):
                            completionHandler(response.data)
                        case .failure(let error):
                            print("KACO NI ERROR: ", error)
                        }
                    }
                }
            }
        }
    }
}

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
        
        print("MODELS",model)
        
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

