//
//  InputText.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI

struct InputText: View {
    var label: String
    var showLabel: Bool
    var borderStyle: String
    
    @Binding var value: String
    
    var body: some View {
        HStack {
            if showLabel {
                Text(label)
                    .frame(width: 70, alignment: .leading)
            }
            
            switch borderStyle {
            case "success":
                TextField(label, text: $value)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.2), radius: 0.2, x: 0.0, y: 1)
                    .accentColor(Color.blue)
            case "error":
                TextField(label, text: $value)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 3)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.2), radius: 0.2, x: 0.0, y: 1)
                    .accentColor(Color.red)
            default:
                TextField(label, text: $value)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.bagirataDimmedLight.opacity(0.2))
                    .cornerRadius(5)
                    .shadow(color: Color.black.opacity(0.2), radius: 0.2, x: 0.0, y: 1)
                    .accentColor(Color.blue)
            }
            
            
        }
    }
}

#Preview {
    InputText(label: "", showLabel: false, borderStyle: "", value: .constant(""))
}
