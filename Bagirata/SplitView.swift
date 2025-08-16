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
            ScrollView {
                VStack(spacing: 16) {
                    // Header Card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(splitted.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                Text(splitted.formatCreatedAt())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Total")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                Text(IDR(splitted.grandTotal))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.bagirataPrimary)
                            }
                        }
                        
                        if !splitted.bankName.isEmpty && !splitted.bankNumber.isEmpty && !splitted.bankAccount.isEmpty {
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Transfer Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Button(action: {
                                    pasteboard.string = splitted.bankNumber
                                    copied = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        copied = false
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(splitted.bankName)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            Text(splitted.bankNumber)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(copied ? .blue : .primary)
                                            Text(splitted.bankAccount)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(spacing: 2) {
                                            Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                                                .foregroundColor(copied ? .blue : .bagirataPrimary)
                                                .font(.title3)
                                            Text(copied ? "Copied!" : "Copy")
                                                .font(.caption)
                                                .foregroundColor(copied ? .blue : .bagirataPrimary)
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color.bagirataDimmedLight)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(16)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
                    
                    // Participants Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Split Breakdown")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("\(splitted.friends.count) people")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.bagirataDimmedLight)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 16)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(splitted.friends.sorted(by: { $0.me && !$1.me })) { friend in
                                ParticipantCard(friend: friend, totalFriends: splitted.friends.count)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Color(UIColor.systemGroupedBackground))
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
                                        
                                        pasteboard.string = "https://bagirata.notblessy.com/view/\(response.data)"
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

struct ParticipantCard: View {
    let friend: SplittedFriend
    let totalFriends: Int
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Main participant info - compact layout
            HStack(alignment: .center, spacing: 12) {
                BagirataAvatar(
                    name: friend.name,
                    width: 40,
                    height: 40,
                    fontSize: 16,
                    background: Color(hex: friend.accentColor),
                    style: friend.me ? .active : .plain
                )
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(friend.name)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if friend.me {
                            Text("(You)")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(.bagirataOk)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 1)
                                .background(Color.bagirataOk.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    
                    Text("\(friend.items.filter { $0.qty > 0 }.count + friend.others.count) items")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 1) {
                    Text(IDR(friend.total))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.bagirataPrimary)
                    
                    Text("from \(IDR(friend.subTotal))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                // Expand/Collapse button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Expandable breakdown section
            if isExpanded {
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.bagirataDimmedLight)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Items in a more compact list
                        ForEach(friend.items.filter { $0.qty > 0 }) { item in
                            CompactItemRow(item: item, totalFriends: totalFriends)
                        }
                        
                        ForEach(friend.others) { item in
                            CompactOtherItemRow(item: item, friendSubTotal: friend.subTotal)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color.bagirataDimmedLight.opacity(0.3))
            }
        }
        .background(Color.bagirataWhite)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

struct CompactItemRow: View {
    let item: FriendItem
    let totalFriends: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Item indicator
            Circle()
                .fill(Color.bagirataPrimary.opacity(0.6))
                .frame(width: 4, height: 4)
            
            // Item name (truncated)
            Text(item.name.truncate(length: 20))
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
            
            // Quantity badge
            Text(item.formattedQuantity(totalFriends))
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.white)
                .cornerRadius(4)
            
            // Price with discount indicator
            VStack(alignment: .trailing, spacing: 2) {
                if item.discount > 0 {
                    // Show original price struck through on top
                    Text(IDR(item.baseSubTotal()))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .strikethrough()
                    
                    // Show discounted price below with discount indicator
                    HStack(spacing: 4) {
                        Text(IDR(item.friendSubTotal))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                        
                        Image(systemName: "tag.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                } else {
                    Text(IDR(item.friendSubTotal))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct CompactOtherItemRow: View {
    let item: FriendOther
    let friendSubTotal: Double
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Item indicator
            Circle()
                .fill(item.type == "addition" || item.type == "tax" ? Color.blue.opacity(0.6) : Color.orange.opacity(0.6))
                .frame(width: 4, height: 4)
            
            // Item name
            Text(item.name)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
            
            // Formula if applicable
            if item.hasFormula() {
                Text(item.getFormula(friendSubTotal))
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.white)
                    .cornerRadius(4)
            }
            
            // Price
            Text(item.getPrice())
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(item.type == "addition" || item.type == "tax" ? .primary : .orange)
        }
        .padding(.vertical, 4)
    }
}

// Keep the old detailed rows but rename them
struct ItemRow: View {
    let item: FriendItem
    let totalFriends: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.bagirataDimmed)
                        .frame(width: 6, height: 6)
                    
                    Text(item.name)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(item.formattedQuantity(totalFriends))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.bagirataDimmedLight)
                        .cornerRadius(6)
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        if item.discount > 0 {
                            Text(IDR(item.baseSubTotal()))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .strikethrough()
                            Text(IDR(item.friendSubTotal))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.orange)
                        } else {
                            Text(IDR(item.friendSubTotal))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            
            // Show discount details if applicable
            if item.discount > 0 {
                HStack {
                    Text("Discount applied:")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    if item.discountIsPercentage {
                        Text("\(String(format: "%.1f", item.discount))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    } else {
                        Text(IDR(item.discount))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                    
                    Text("Saved \(IDR(item.discountAmount()))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
                .padding(.leading, 14)
                .padding(.top, 2)
            }
        }
    }
}

struct OtherItemRow: View {
    let item: FriendOther
    let friendSubTotal: Double
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.bagirataDimmed)
                    .frame(width: 6, height: 6)
                
                Text(item.name)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                if item.hasFormula() {
                    Text(item.getFormula(friendSubTotal))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.bagirataDimmedLight)
                        .cornerRadius(6)
                }
                
                Text(item.getPrice())
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(item.type == "addition" || item.type == "tax" ? .primary : .orange)
            }
        }
    }
}

#Preview {
    SplitView(selectedTab: .constant(.result), scannerResultActive: .constant(true), splitted: .constant(Splitted.example()))
}
