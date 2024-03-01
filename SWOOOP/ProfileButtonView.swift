//
//  ProfileButtonView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ProfileButtonView: View {
    var cast: Cast
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            AsyncImage(url: URL(string: cast.pfp)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        .padding()
                    
                } else if phase.error != nil {
                    Text("Failed to load image")
                } else {
                    ProgressView()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
