//
//  CastFormView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/4/24.
//

import SwiftUI

struct CastFormView: View {
    
    @State public var message: String = ""
    
    var body: some View {
        VStack{
            Form{
                TextField("Type up a cast...", text: $message)
            }
            Button(action: {
                CastManager.shared.postCast(text: message, parentUrl: "")
                print("Button tapped!")
            }) {
                Text("Send it")
                    .padding(.horizontal, 100)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CastFormView()
}
