//
//  BannerAdView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 07/08/24.
//

import SwiftUI

struct BannerAdView: View {
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                BannerView()
                    .frame(height: 60)
                Spacer()
            }
            
        }
    }
}

#Preview {
    BannerAdView()
}
