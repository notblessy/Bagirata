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
    
    func recognizeText(withCompletionHandler completionHandler:@escaping (String) -> Void) {
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
                    completionHandler(text.joined(separator: " "))
                }
            }
        }
    }
}

