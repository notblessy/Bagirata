//
//  Formatter.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import Foundation

func IDR(_ price: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencySymbol = "IDR"
    numberFormatter.maximumFractionDigits = 0
    
    if let formattedString = numberFormatter.string(from: NSNumber(value: price)) {
        return formattedString
    } else {
        return "IDR\(price)" // Fallback if formatting fails
    }
}

func Percent(_ amount: Double) -> String {
    return "\(Int(amount))%"
}

func qty(_ qty: Double) -> String {
    return "\(Int(qty))x"
}

func isNumber(_ string: String) -> Bool {
    let regex = "^[0-9]*\\.?[0-9]+$"
    let test = NSPredicate(format:"SELF MATCHES %@", regex)
    return test.evaluate(with: string)
}
