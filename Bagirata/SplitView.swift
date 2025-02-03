//
//  SplitView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 06/07/24.
//

import SwiftUI
import SwiftData

struct SplitView: View {
    @Environment(\.modelContext) private var context
    
    private let pasteboard = UIPasteboard.general
    
    @State var isLoading: Bool = false
    @State var showAlert: Bool = false
    @State var errMessage: String = ""
    @State var link: String = ""
    
    @Binding var selectedTab: Tabs
    @Binding var scannerResultActive: Bool
    @Binding var splitted: Splitted
    
    @State var copied: Bool = false
    
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
                    
                    if !splitted.bankName.isEmpty,!splitted.bankNumber.isEmpty, !splitted.bankAccount.isEmpty {
                        Section("Transfer Information") {
                            Button(action: {
                                pasteboard.string = splitted.bankNumber
                                copied = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    copied = false
                                }
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(splitted.bankName)
                                        .fontWeight(.bold)
                                    HStack {
                                        if !copied {
                                            Text(splitted.bankNumber)
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
                                    Text(splitted.bankAccount)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                            })
                            .listRowSeparator(.hidden)
                        }
                    }
                    
                    Section("Bagirata Split") {
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
                                                    Text("- \(item.name.truncate(length: 22))")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.gray)
                                                    Spacer()
                                                    Text(item.formattedQuantity(splitted.friends.count))
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.gray)
                                                    if item.equal {
                                                        Text(IDR(item.splittedPrice(splitted.friends.count)))
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
                                                Text("- \(item.name.truncate(length: 22))")
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
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        selectedTab = .history
                        scannerResultActive = false
                        splitted = Splitted()
                    }, label: {
                        Label("History", systemImage: "chevron.left")
                    })
                }
                
                ToolbarItem {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Button(action: {
                            isLoading = true
                            
                            saveSplit(payload: splitted) { res in
                                switch res {
                                case .success(let response):
                                    if response.success {
                                        scannerResultActive = false
                                        
                                        isLoading = false
                                        
                                        pasteboard.string = "http://bagirata.co/view/\(response.data)"
                                        showAlert = true
                                    }
                                case .failure(let error):
                                    errMessage = error.localizedDescription
                                    isLoading = false
                                    showAlert = true
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
                Alert(title: Text("Share Success"), message: Text("Link copied to clipboard!"), dismissButton: .default(Text("Dismiss"), action: {
                        selectedTab = .history
                        splitted = Splitted()
                }))
            } else {
                Alert(title: Text("Error Saving Split"), message: Text(errMessage), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
}

#Preview {
    SplitView(selectedTab: .constant(.result), scannerResultActive: .constant(true), splitted: .constant(Splitted.example()))
}
