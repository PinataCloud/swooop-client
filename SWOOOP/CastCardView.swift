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
        VStack(alignment: .leading) {
            HStack{
                    AsyncImage(url: URL(string: cast.pfp)) { phase in
                        if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    } else if phase.error != nil {
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                    }
                Text("@\(cast.username)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            
            Text(cast.castText)
                .foregroundColor(.white)
                .font(.title)
        }
        .padding(.horizontal)
    }
}
