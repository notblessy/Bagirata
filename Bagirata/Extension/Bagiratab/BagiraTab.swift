//
//  BagiraTab.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI

enum Tabs: Int {
    case history = 0
    case friend = 1
    case result = 2
}

struct BagiraTab: View {
    @Binding var selectedTab: Tabs
    @Binding var showScanner: Bool
    @Binding var scannerResultActive: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                selectedTab = .history
            }, label: {
                BagiratabButton(label: "History", image: "book.pages", isActive: selectedTab == .history)
            })
            .tint(selectedTab == .history ? Color.blue : Color.gray)
            
            Button(action: {
                if scannerResultActive {
                    selectedTab = .result
                } else {
                    showScanner.toggle()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .fill(Color.blue)
                        .frame(width: 60, height: 60)
                    VStack {
                        Image(systemName: scannerResultActive ? "doc.on.clipboard" : "doc.text.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: 50)
                }
            })
            .tint(Color.white)
            
            Button(action: {
                selectedTab = .friend
            }, label: {
                BagiratabButton(label: "Friends", image: "person", isActive: selectedTab == .friend)
            })
            .tint(selectedTab == .friend ? Color.blue : Color.gray)
        }
        .frame(height: 82)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
        .background(ignoresSafeAreaEdges: .bottom)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    BagiraTab(selectedTab: .constant(.friend), showScanner: .constant(false), scannerResultActive: .constant(true))
}
