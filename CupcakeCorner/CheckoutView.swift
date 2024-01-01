//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Evangelos Pipis on 01/01/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingMessage = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is: \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
            .navigationTitle("Order")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .alert("Thank you", isPresented: $showingMessage) {} message: {
                Text(confirmationMessage)
            }
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let serverURL = URL(string: "https://reqres.in/api/cupcakes")!
        var apiRequest = URLRequest(url: serverURL)
        apiRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        apiRequest.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: apiRequest, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type]) is on its way!"
            showingMessage = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
