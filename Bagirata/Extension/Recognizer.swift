//
//  Recognizer.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import Foundation
import SwiftUI
import Vision

//func recognizer() {
//    @Binding var recognizedText: String
//    
//    let image = UIImage(resource: .receipt)
//    
//    guard let cgImage = image.cgImage else { return }
//    
//    let handler = VNImageRequestHandler(cgImage: cgImage)
//    let request = VNRecognizeTextRequest { request, error in
//        guard error == nil else {
//            print(error?.localizedDescription ?? "")
//            return
//        }
//        
//        guard let result = request.results as? [VNRecognizedTextObservation] else {
//            return
//        }
//        
//        let recogArr = result.compactMap { result in
//            result.topCandidates(1).first?.string
//        }
//        
//        DispatchQueue.main.async {
//            recognizedText = recogArr.joined(separator: "\n")
//        }
//    }
//    
//    request.recognitionLevel = .accurate
//    
//    do {
//        try handler.perform([request])
//    } catch {
//        print(error.localizedDescription)
//    }
//}
