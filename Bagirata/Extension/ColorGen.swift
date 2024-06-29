//
//  ColorGen.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI

func colorGen() -> Color {
    let base: Double = 0.7
    let red = (Double.random(in: 0...1) + base) / 2
    let green = (Double.random(in: 0...1) + base) / 2
    let blue = (Double.random(in: 0...1) + base) / 2
    
    return Color(red: red, green: green, blue: blue)
}
