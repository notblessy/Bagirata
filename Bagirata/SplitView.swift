//
//  SplitView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 06/07/24.
//

import SwiftUI

struct SplitView: View {
    @Binding var selectedTab: Tabs
    @Binding var splitted: Splitted
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(splitted.name)
                                .font(.title)
                                .bold()
                            Text(splitted.formatCreatedAt())
                                .font(.system(size: 16))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Text(IDR(splitted.grandTotal))
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    Section("Split") {
                        ForEach(splitted.friends.sorted(by: { $0.me && !$1.me })) { friend in
                            VStack(alignment: .leading) {
                                HStack(alignment: .top) {
                                    BagirataAvatar(name: friend.name, width: 32, height: 32, fontSize: 15, background: Color(hex: friend.accentColor), style: .plain)
                                   
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(friend.name)
                                            Spacer()
                                            Text(IDR(friend.total))
                                        }
                                        
                                        ForEach(friend.items) { item in
                                            HStack {
                                                Text("x\(item.qty)")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Text(item.name.truncate(length: 22))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Text(IDR(item.price))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                        
                                        ForEach(friend.others) { item in
                                            HStack {
                                                Text(item.name.truncate(length: 22))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Text(IDR(item.price))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Label("Back", systemImage: "chevron.left")
                    })
                }
                
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        Text("Share")
                    })
                    
                }
            }
            }
    }
}

#Preview {
    SplitView(selectedTab: .constant(.result), splitted: .constant(Splitted.example()))
}
