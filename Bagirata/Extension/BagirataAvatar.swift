//
//  InitialView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI

struct BagirataAvatar: View {
    let name: String
    let width: CGFloat
    let height: CGFloat
    let fontSize: CGFloat
    let background: Color
    
    var initials: String {
        let nameComponents = name.split(separator: " ")
        if nameComponents.count > 1 {
            // Use the first letter of the first two components
            return String(nameComponents[0].prefix(1) + nameComponents[1].prefix(1)).uppercased()
        } else {
            // Use the first two letters of the single component name
            return String(nameComponents[0].prefix(2)).uppercased()
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(background)
                .frame(width: width, height: height)
            
            Text(initials)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    BagirataAvatar(name: "FR", width: 32, height: 32, fontSize: 16, background: colorGen())
}
