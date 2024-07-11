//
//  String.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import Foundation

extension String {
    func truncate(length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
}

let charset = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

func generateSlug(length: Int) -> String {
    var result = ""
    for _ in 0..<length {
        let randomIndex = Int(arc4random_uniform(UInt32(charset.count)))
        let randomCharacter = charset[randomIndex]
        
        result.append(randomCharacter)
    }
    return result
}
