//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Evangelos Pipis on 01/01/2024.
//

import SwiftUI

struct AddressView: View {
    // The @Bindable property wrapper creates the missing bindings for us – it produces two-way bindings that are able to work with the @Observable macro, without having to use @State to create local data
    @Bindable var order: Order
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }
                
                Section {
                    NavigationLink("Check out") {
                        Text("Detail View")
                    }
                    .disabled(order.hasValidAddress == false)
                }
            }
        }
    }
}

#Preview {
    AddressView(order: Order())
}
