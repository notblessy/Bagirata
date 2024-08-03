//
//  FriendAvatarGroup.swift
//  Bagirata
//
//  Created by Frederich Blessy on 03/08/24.
//

import SwiftUI

struct FriendAvatarGroup: View {
    let friends: [AssignedFriend]
    let width: CGFloat
    let height: CGFloat
    let overlapOffset: CGFloat
    let fontSize: CGFloat

    var body: some View {
        HStack(spacing: -overlapOffset) {
            ForEach(friends) { friend in
                BagirataAvatar(name: friend.name, width: width, height: height, fontSize: fontSize, background: Color(hex: friend.accentColor), style: .plain)
            }
        }
    }
}

#Preview {
    FriendAvatarGroup(friends: AssignedFriend.examples(), width: 20, height: 20, overlapOffset: 13, fontSize: 10)
}
