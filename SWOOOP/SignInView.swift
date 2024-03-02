//
//  SignInView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/2/24.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        Image("bg")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all) // Fill the entire screen
            .overlay(
                Button(action: {
                    // Add your action here
                    print("Button tapped!")
                }) {
                    Text("Sign in with Warpcast")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                    .padding(.top, 200)
            )
    }
}

#Preview {
    SignInView()
}
