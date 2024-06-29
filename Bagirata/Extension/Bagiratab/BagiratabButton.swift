//
//  BagiratabButton.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI

struct BagiratabButton: View {
    var label: String
    var image: String
    var isActive: Bool
    
    var body: some View {
        GeometryReader { geo in
            if isActive {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geo.size.width/2, height: 5)
                    .padding(.leading, geo.size.width/4)
            }
            
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(label)
                    .font(.system(size: 12))
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    BagiratabButton(label: "History", image: "book.pages", isActive: true)
}
