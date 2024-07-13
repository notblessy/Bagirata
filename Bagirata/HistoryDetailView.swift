//
//  HistoryDetailView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 12/07/24.
//

import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    @Environment(\.modelContext) private var context
    @Query() var banks: [Bank]
    
    var bank: Bank? { banks.first }
    
    let split: Splitted
    
    private let pasteboard = UIPasteboard.general
    
    @State private var isLoading: Bool = false
    @State private var showAlertShare: Bool = false
    @State private var showAlertError: Bool = false
    @State private var errMessage: String = ""
    
    @State var copied: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text(split.name)
                            .font(.title)
                            .bold()
                        Text(split.formatCreatedAt())
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Text(IDR(split.grandTotal))
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                
                if let bankName = bank?.name, let bankNumber = bank?.number, let accountName = bank?.accountName {
                    Section("Transfer Information") {
                        Button(action: {
                            pasteboard.string = String(bank?.number ?? 0)
                            copied = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                copied = false
                            }
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(bankName)
                                    .fontWeight(.bold)
                                HStack {
                                    if !copied {
                                        Text(String(bankNumber))
                                        Image(systemName: "doc.on.doc.fill")
                                            .resizable()
                                            .frame(width: 15, height: 18)
                                    } else {
                                        Text("Number Copied!")
                                            .foregroundColor(.blue)
                                        Image(systemName: "doc.on.doc.fill")
                                            .resizable()
                                            .frame(width: 15, height: 18)
                                            .foregroundStyle(.blue)
                                    }
                                }
                                .padding(.top, -8)
                                Text(accountName)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                            }
                        })
                        .listRowSeparator(.hidden)
                    }
                }
                
                Section("Bagirata Split") {
                    ForEach(split.friends.sorted(by: { $0.me && !$1.me })) { friend in
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
                                        if item.qty > 0 {
                                            HStack {
                                                Text(item.name.truncate(length: 22))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Text("x\(item.qty)")
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Text(IDR(item.price))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                            }
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
            .listStyle(.plain)
            .toolbar {
                ToolbarItem {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Button(action: {
                            isLoading = true

                            saveSplit(payload: split) { res in
                                switch res {
                                case .success(let response):
                                    if response.success {

                                        isLoading = false

                                        pasteboard.string = "http://bagirata.co/\(response.data)"
                                        showAlertShare = true
                                    }
                                case .failure(let error):
                                    errMessage = error.localizedDescription
                                    isLoading = false
                                    showAlertError = true
                                }
                            }
                        }, label: {
                            Text("Share")
                        })
                    }
                }
            }
        }
        .alert(isPresented: $showAlertShare) {
            Alert(title: Text("Share Success"), message: Text("Link copied to clipboard!"), dismissButton: .default(Text("Dismiss")))
        }
        .alert(isPresented: $showAlertError) {
            Alert(title: Text("Share Error"), message: Text(errMessage), dismissButton: .default(Text("Dismiss")))
        }
    }
}

#Preview {
    HistoryDetailView(split: Splitted.example())
}
