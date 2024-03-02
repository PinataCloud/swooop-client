//
//  CastFormView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/2/24.
//

import SwiftUI

struct CastFormView: View {
    @State var cast: String = ""
    
    var body: some View {
        Form {
            TextField("Type a message...", text: $cast)
        }
    }
}

#Preview {
    CastFormView()
}
