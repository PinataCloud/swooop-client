//
//  CastCard.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct CastCardView: View {
    var cast: Cast
    
    var body: some View {
        VStack {
            Text(cast.castText)
                HStack{
                    AsyncImage(url: URL(string: cast.pfp)) { phase in
                        if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, height: 42)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    } else if phase.error != nil {
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                }
                Text("@\(cast.username)")
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 800)
    }
}

