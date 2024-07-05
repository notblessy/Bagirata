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
