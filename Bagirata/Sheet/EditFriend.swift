//
//  UpdateFriend.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct EditFriend: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    let friend: Friend
    @State var name: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Edit Friend")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    Form {
                        TextField("Name", text: $name)
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    
                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Dismiss")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            friend.name = name
                            dismiss()
                        }, label: {
                            Text("Save")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .disabled(name.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .onAppear {
                    name = friend.name
                }
            }
        }
    }
}
