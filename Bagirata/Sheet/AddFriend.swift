//
//  CreateFriend.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct AddFriend: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    
    private var color: Color = colorGen()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Friend")
                    .font(.title2)
                    .fontWeight(.medium)
                
                InputText(label: "Name", showLabel: false, borderStyle: "", value: $name)
                    .padding(.top)

                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Dismiss")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        let friend = Friend(id: UUID(), name: name, me: false, accentColor: color.toHex(), createdAt: Date())
                        context.insert(friend)
                        dismiss()
                    }, label: {
                        Text("Add Friend")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .disabled(name.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 5)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    AddFriend()
}
