//
//  CastCard.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI
import AVKit

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
                        .frame(width: 40, height: 40)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    } else if phase.error != nil {
                        Image(systemName: "person.crop.circle.fill") // Use a default image if loading fails
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding()
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                }
                Text("@\(cast.username)")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
            }
            Text(cast.castText)
                .foregroundColor(.white)
                .font(.title2)
            VStack {
                ForEach(cast.embedUrl, id: \.url) { embedUrl in
                    if embedUrl.url.lowercased().hasSuffix(".jpg") || embedUrl.url.lowercased().hasSuffix(".png") || embedUrl.url.lowercased().hasSuffix(".jpeg") || embedUrl.url.lowercased().hasSuffix(".gif") {
                        // Render Image
                        HStack {
                            Spacer()
                            AsyncImage(url:URL(string: embedUrl.url)) { phase in
                                if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                } else if phase.error != nil {
                                    Text("Failed to load image")
                                } else {
                                    ProgressView()
                                }
                            }
                            Spacer()
                        }
                    } else if embedUrl.url.lowercased().hasSuffix(".mp4") {
                        // Render Video
                        if let videoURL = URL(string: embedUrl.url) {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(width: 200, height: 200)
                        }
                    } else {
                        // Unsupported format
                        Text("Unsupported media format")
                    }
                }
            }
            VStack {
                ForEach(cast.embedCast, id: \.castId.hash) { castId in
                    let urlString = "https://supercast.xyz/c/\(castId.castId.hash)"
                    Text(urlString)
                        .padding()
                        .onTapGesture {
                            if let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
