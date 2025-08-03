//
//  AssignItem.swift
//  Bagirata
//
//  Created by Frederich Blessy on 26/07/25.
//

import SwiftUI

struct AssignItem: View {
    @Environment(\.dismiss) var dismiss

    @Binding var splitItem: SplitItem
    @Binding var item: AssignedItem

    @State private var selectedParticipants: Set<UUID> = []
    @State private var participantQuantities: [UUID: Double] = [:]
    @State private var isEqualSplit: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        HStack {
                            Text("\(qty(item.qty)) \(IDR(item.price))")
                                .foregroundStyle(.gray)
                            Spacer()
                            Text(IDR(item.price * item.qty))
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack {
                            
                        }
                    }
                    .padding()
                    .cornerRadius(12)
                    .shadow(color: Color.accentColor.opacity(0.08), radius: 4, x: 0, y: 2)
                    .padding(.top)

                    HStack {
                        Toggle("Split Equally", isOn: $isEqualSplit)
                            .onChange(of: isEqualSplit) { _, newValue in
                                if newValue {
                                    equalSplitQuantities()
                                } else {
                                    resetQuantities()
                                }
                            }
                    }
                    .padding()

                    List {
                        Section("Participants") {
                            ForEach(splitItem.friends) { friend in
                                HStack {
                                    BagirataAvatar(
                                        name: friend.name,
                                        width: 40,
                                        height: 40,
                                        fontSize: 20,
                                        background: Color(hex: friend.accentColor),
                                        style: selectedParticipants.contains(friend.friendId) ? .active : .plain
                                    )

                                    VStack(alignment: .leading) {
                                        Text(friend.name)
                                            .font(.system(size: 16))
                                        if selectedParticipants.contains(friend.friendId) {
                                            Text("Qty: \(formatQuantity(participantQuantities[friend.friendId] ?? 0))")
                                                .font(.system(size: 12))
                                                .foregroundStyle(.gray)
                                        }
                                    }

                                    Spacer()

                                    if selectedParticipants.contains(friend.friendId) && !isEqualSplit {
                                        HStack {
                                            Button(action: {
                                                decrementQuantity(for: friend.friendId)
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                            .buttonStyle(.bordered)

                                            Text(formatQuantity(participantQuantities[friend.friendId] ?? 0))
                                                .frame(minWidth: 40)
                                                .font(.system(size: 14, weight: .medium))

                                            Button(action: {
                                                incrementQuantity(for: friend.friendId)
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.blue)
                                            }
                                            .buttonStyle(.bordered)
                                            .disabled(getTotalAssignedQuantity() >= item.qty)
                                        }
                                    } else if !isEqualSplit {
                                        Button(action: {
                                            toggleParticipantSelection(friend.friendId)
                                        }) {
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.blue)
                                        }
                                        .disabled(getRemainingQuantity() <= 0 && !selectedParticipants.contains(friend.friendId))
                                    }
                                }
                                .padding(.vertical, 4)
                                .listRowBackground(Color.clear)
                                .contentShape(Rectangle())
                            }
                        }

                        if !selectedParticipants.isEmpty {
                            Section("Summary") {
                                HStack {
                                    Text("Total Assigned")
                                    Spacer()
                                    Text("\(formatQuantity(getTotalAssignedQuantity())) / \(formatQuantity(item.qty))")
                                        .foregroundColor(isValidAssignment() ? .green : .orange)
                                }
                                
                                HStack {
                                    Text("Remaining")
                                    Spacer()
                                    Text(formatQuantity(getRemainingQuantity()))
                                        .foregroundColor(getRemainingQuantity() == 0 ? .green : .orange)
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)

                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding(5)
                        }
                        .buttonStyle(.bordered)

                        Button(action: {
                            saveAssignments()
                            dismiss()
                        }) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding(5)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canSaveAssignment())
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .onAppear {
                loadCurrentAssignments()
            }
        }
    }
    
    private func loadCurrentAssignments() {
        selectedParticipants.removeAll()
        participantQuantities.removeAll()

        for friend in item.friends {
            selectedParticipants.insert(friend.friendId)
            participantQuantities[friend.friendId] = friend.qty
        }

        isEqualSplit = item.equal
    }
    
    private func toggleParticipantSelection(_ friendId: UUID) {
        if selectedParticipants.contains(friendId) {
            // Remove participant
            selectedParticipants.remove(friendId)
            participantQuantities.removeValue(forKey: friendId)
        } else {
            // Add participant with default quantity
            selectedParticipants.insert(friendId)
            participantQuantities[friendId] = getDefaultQuantity()
        }
    }
    
    private func getDefaultQuantity() -> Double {
        let remaining = getRemainingQuantity()
        
        if remaining < 1.0 {
            return remaining
        } else {
            return item.qty == 1 ? 0.1 : 1.0
        }
    }
    
    private func getMinimumIncrement() -> Double {
        return item.qty == 1 ? 0.1 : 1.0
    }
    
    private func incrementQuantity(for friendId: UUID) {
        let currentQty = participantQuantities[friendId] ?? 0
        let totalWithoutCurrent = getTotalAssignedQuantity() - currentQty
        let remainingQty = item.qty - getTotalAssignedQuantity()
        
        // Determine increment based on current quantity and remaining space
        let increment: Double
        if remainingQty < 1.0 {
            // If remaining quantity is less than 1, use the exact remaining amount
            increment = remainingQty
        } else if currentQty == 0 || currentQty >= 1 {
            increment = 1.0
        } else if currentQty >= 0.1 && currentQty < 1.0 {
            increment = 0.1
        } else {
            increment = 0.1 // fallback for edge cases
        }
        
        let newQty = currentQty + increment
        
        // Check if we can assign this quantity without exceeding total
        if totalWithoutCurrent + newQty <= item.qty {
            participantQuantities[friendId] = roundToTwoDecimals(newQty)
        }
    }

    private func decrementQuantity(for friendId: UUID) {
        let currentQty = participantQuantities[friendId] ?? 0
        let decrement = currentQty > 1 ? 1.0 : 0.1
        let newQty = max(0, currentQty - decrement)
        
        if newQty < 0.1 {
            // Remove participant if quantity becomes less than 0.1
            selectedParticipants.remove(friendId)
            participantQuantities.removeValue(forKey: friendId)
        } else {
            participantQuantities[friendId] = roundToTwoDecimals(newQty)
        }
    }
    
    private func canIncrementQuantity(for friendId: UUID) -> Bool {
        let currentQty = participantQuantities[friendId] ?? 0
        let increment = getMinimumIncrement()
        let totalWithoutCurrent = getTotalAssignedQuantity() - currentQty
        return totalWithoutCurrent + increment <= item.qty
    }

    private func equalSplitQuantities() {
        // Always select all friends as participants
        selectedParticipants.removeAll()
        for friend in splitItem.friends {
            selectedParticipants.insert(friend.friendId)
        }
        
        guard !selectedParticipants.isEmpty else { return }
        
        let participantCount = selectedParticipants.count
        let baseQty = floor((item.qty / Double(participantCount)) * 100) / 100 // Floor to 2 decimal places
        let remainder = roundToTwoDecimals(item.qty - (baseQty * Double(participantCount)))
        
        let friendIds = Array(selectedParticipants)
        
        // Assign base quantity to all participants
        for friendId in friendIds {
            participantQuantities[friendId] = baseQty
        }
        
        // Distribute the remainder to the first few participants
        if remainder > 0 {
            let remainderPerParticipant = 0.01
            let participantsToGetExtra = Int(remainder / remainderPerParticipant)
            
            for i in 0..<min(participantsToGetExtra, friendIds.count) {
                let friendId = friendIds[i]
                participantQuantities[friendId] = roundToTwoDecimals((participantQuantities[friendId] ?? 0) + remainderPerParticipant)
            }
        }
    }

    private func resetQuantities() {
        // Always select all friends as participants
        selectedParticipants.removeAll()
        for friend in splitItem.friends {
            selectedParticipants.insert(friend.friendId)
        }
        
        guard !selectedParticipants.isEmpty else { return }
        
        let participantCount = selectedParticipants.count
        let baseQty = floor((item.qty / Double(participantCount)) * 100) / 100 // Floor to 2 decimal places
        let remainder = roundToTwoDecimals(item.qty - (baseQty * Double(participantCount)))
        
        let friendIds = Array(selectedParticipants)
        
        // Assign base quantity to all participants
        for friendId in friendIds {
            participantQuantities[friendId] = baseQty
        }
        
        // Distribute the remainder to the first few participants
        if remainder > 0 {
            let remainderPerParticipant = 0.01
            let participantsToGetExtra = Int(remainder / remainderPerParticipant)
            
            for i in 0..<min(participantsToGetExtra, friendIds.count) {
                let friendId = friendIds[i]
                participantQuantities[friendId] = roundToTwoDecimals((participantQuantities[friendId] ?? 0) + remainderPerParticipant)
            }
        }
    }

    private func getTotalAssignedQuantity() -> Double {
        return roundToTwoDecimals(participantQuantities.values.reduce(0, +))
    }
    
    private func getRemainingQuantity() -> Double {
        let remaining = roundToTwoDecimals(item.qty - getTotalAssignedQuantity())
        
        // Handle negative zero and very small negative numbers due to floating point precision
        return remaining <= 0 ? 0 : remaining
    }
    
    private func isValidAssignment() -> Bool {
        let totalAssigned = getTotalAssignedQuantity()
        return totalAssigned <= item.qty && totalAssigned > 0
    }
    
    private func canSaveAssignment() -> Bool {
        return !selectedParticipants.isEmpty && 
        abs(getTotalAssignedQuantity() - item.qty) < 0.01
    }
    
    private func roundToTwoDecimals(_ value: Double) -> Double {
        return (value * 100).rounded() / 100
    }

    private func formatQuantity(_ quantity: Double) -> String {
        if quantity.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(quantity))
        } else {
            return String(format: "%.1f", quantity)
        }
    }

    private func saveAssignments() {
        guard canSaveAssignment() else { return }
        
        var updatedItem = item
        updatedItem.friends.removeAll()
        updatedItem.equal = isEqualSplit

        for friendId in selectedParticipants {
            if let friend = splitItem.friends.first(where: { $0.friendId == friendId }),
               let qty = participantQuantities[friendId], qty > 0 {
                let subTotal = roundToTwoDecimals(item.price * qty)
                let assignedFriend = AssignedFriend(
                    friendId: friend.friendId,
                    name: friend.name,
                    me: friend.me,
                    accentColor: friend.accentColor,
                    qty: qty,
                    subTotal: subTotal
                )
                updatedItem.friends.append(assignedFriend)
            }
        }

        item = updatedItem
        splitItem.updateItem(updatedItem)
    }
}

#Preview {
    AssignItem(
        splitItem: .constant(SplitItem.example()),
        item: .constant(AssignedItem.example())
    )
}
