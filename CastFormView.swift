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
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
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
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .foregroundColor(Color(red: 0.314, green: 0.169, blue: 0.365))
                        .background(
                                    LinearGradient(
                                        colors: [Color(red: 0.431, green: 0.988, blue: 1), Color(red: 0.867, green: 0.435, blue: 1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                        )
                        .cornerRadius(10)
                }
            }
            .padding()
            Form{
                TextField("Type up a cast...", text: $message, axis: .vertical)
            }
        }
        .padding()
    }
}
