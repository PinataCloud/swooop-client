//
//  CastFormView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/4/24.
//

import SwiftUI

struct CastFormView: View {
    
    var toggleCastFormView: () -> Void
    @State public var message: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.toggleCastFormView()
                }) {
                    Text("Cancel")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                Spacer()
                Button(action: {
                    CastManager.shared.postCast(text: message, parentUrl: "")
                    message = ""
                    self.toggleCastFormView()
                    print("Button tapped!")
                }) {
                    Text("Send it")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            Form{
                TextField("Type up a cast...", text: $message, axis: .vertical)
            }
        }
    }
}

