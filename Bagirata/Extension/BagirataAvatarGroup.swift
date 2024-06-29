//
//  BagirataAvatarGroup.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct BagirataAvatarGroup: View {
    let imageNames: [String]
    let width: CGFloat
    let height: CGFloat
    let overlapOffset: CGFloat
    let fontSize: CGFloat

    var body: some View {
        HStack(spacing: -overlapOffset) {
            ForEach(imageNames, id: \.self) { imageName in
                BagirataAvatar(name: imageName, width: width, height: height, fontSize: fontSize, background: colorGen())
            }
        }
    }
}

#Preview {
    BagirataAvatarGroup(imageNames: ["image1", "example1"], width: 20, height: 20, overlapOffset: 13, fontSize: 10)
}
