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
    
    let split: Splitted
    
    private let pasteboard = UIPasteboard.general
    
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
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
                
                if !split.bankName.isEmpty, !split.bankNumber.isEmpty, !split.bankAccount.isEmpty {
                    Section("Transfer Information") {
                        Button(action: {
                            pasteboard.string = split.bankNumber
                            copied = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                copied = false
                            }
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(split.bankName)
                                    .fontWeight(.bold)
                                HStack {
                                    if !copied {
                                        Text(split.bankNumber)
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
                                Text(split.bankAccount)
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
                                    
                                    HStack {
                                        Text("Subtotal")
                                            .font(.system(size: 12))
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(IDR(friend.subTotal))
                                            .font(.system(size: 12))
                                            .foregroundStyle(.gray)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    ForEach(friend.items) { item in
                                        if item.qty > 0 {
                                            HStack {
                                                Text(item.name.truncate(length: 22))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Text(item.formattedQuantity(split.friends.count))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                                if item.equal {
                                                    Text(IDR(item.splittedPrice(split.friends.count)))
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.gray)
                                                        .padding(.leading, 3)
                                                } else {
                                                    Text(IDR(item.price * item.qty))
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.gray)
                                                        .padding(.leading, 3)
                                                }
                                            }
                                        }
                                    }
                                    
                                    ForEach(friend.others) { item in
                                        HStack {
                                            Text(item.name.truncate(length: 22))
                                                .font(.system(size: 12))
                                                .foregroundStyle(.gray)
                                            Spacer()
                                            if item.hasFormula() {
                                                Text(item.getFormula(friend.subTotal))
                                                    .font(.system(size: 12))
                                                    .foregroundStyle(.gray)
                                            }
                                            Text(item.getPrice())
                                                .font(.system(size: 12))
                                                .foregroundStyle(.gray)
                                                .padding(.leading, 3)
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
                                        showAlert.toggle()
                                    }
                                case .failure(let error):
                                    errMessage = error.localizedDescription
                                    isLoading = false
                                    showAlert.toggle()
                                }
                            }
                        }, label: {
                            Text("Share")
                        })
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            if errMessage.isEmpty {
                Alert(title: Text("Share Success"), message: Text("Link copied to clipboard!"), dismissButton: .default(Text("Dismiss")))
            } else {
                Alert(title: Text("Share Error"), message: Text(errMessage), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
}

#Preview {
    HistoryDetailView(split: Splitted.example())
}
