//
//  DisableFormView.swift
//  CupcakeCorner
//
//  Created by Evangelos Pipis on 29/12/2023.
//

import SwiftUI

struct DisableFormView: View {
    @State private var username = ""
    @State private var email = ""
    
    // Create a computed property that will be used to disable the button.
    // This can also be passed directly to the .disabled modifier but it's cleaner to store it in a computed property.
    var disableForm: Bool {
        username.isEmpty || email.isEmpty
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Create account...")
                }
                // This takes a condition to check, and if the condition is true then whatever it’s attached to won’t respond to user input.
                .disabled(disableForm)
            }
        }
    }
}

#Preview {
    DisableFormView()
}
