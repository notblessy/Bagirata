//
//  UpdateFriend.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct UpdateFriend: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    var friend: Friend
    @State var name: String = ""
    
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
                        friend.name = name
                        dismiss()
                    }, label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .disabled(name.isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 5)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                name = friend.name
            }
        }
    }
}
