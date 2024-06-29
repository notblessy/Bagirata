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
    
    func recognizeText(withCompletionHandler completionHandler:@escaping ([Item]) -> Void) {
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
                var items: [Item] = []
                
                for text in texts {
                    var index = 0
                    while index < text.count {
                        if index + 1 < text.count {
                            let item = text[index]
                            let priceString = text[index + 1]
    
                            if isNumber(priceString) && isNumber(String(item.prefix(1)))  {
                                let qty = Int(item.prefix(1))
                                let price = Int(priceString)
                                let name = String(item.dropFirst(2))
                                
                                if qty ?? 0 > 0 && price ?? 0 > 0 {
                                    items.append(Item(id: UUID(), qty: qty ?? 0, price: price ?? 0, name: name))
                                }
                            }
                        }
    
                        index += 1
                    }
                }
                
                for text in texts {
                    var index = 0
                    
                    print(text)
                    
                    while index < text.count {
                        if index + 1 < text.count {
                            let name = text[index]
                            let nextString = text[index + 1]
                            let components = nextString.split(separator: "x")
                            
                            if components.count == 2 {
                                let qtyString = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                let priceString = components[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: "")
                                
                                if let qty = Int(qtyString), let price = Int(priceString) {
                                    if qty > 0 && price > 0 {
                                        let item = Item(qty: qty, price: price, name: name)
                                        items.append(item)
                                    }
                                }
                            }
                        }
                        
                        index += 1
                    }
                }
                
                completionHandler(items)
            }
        }
    }
}
