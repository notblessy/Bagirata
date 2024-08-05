//
//  Color.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
    
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255.0)
        let g = Int(green * 255.0)
        let b = Int(blue * 255.0)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

extension Color {
    public static let bagirataPrimary = Color(hex: "FFAB09")
    public static let bagirataWhite = Color(hex: "F9F9F9")
    public static let bagirataOk = Color(hex: "4A93CF")
    public static let bagirataError = Color(hex: "FADAD6")
    public static let bagirataDimmed = Color(hex: "CACED0")
    public static let bagirataDimmedLight = Color(hex: "F4F4F4")
}

struct NoFadeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1.0 : 1.0) // Maintain opacity regardless of press state
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Optional: add a scaling effect
            .animation(.none, value: configuration.isPressed) // Disable animations
    }
}
