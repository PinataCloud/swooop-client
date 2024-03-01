//
//  ContentView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct Embed: Codable {
    let type: String
    let url: String
}

struct Cast: Codable {
    let id: Int
    let castText: String
    let embeds: [Embed]
    let username: String
    let pfp: String
    let timestamp: Int
}

struct ContentView: View {
    
    @State private var data = Cast(
        id: 1,
        castText: "hello world!",
        embeds: [],
        username: "stevedylandev.eth",
        pfp: "https://gateway.pinata.cloud/ipfs/QmVLwvmGehsrNEvhcCnnsw5RQNseohgEkFNN1848zNzdng?filename=pinnie.png",
        timestamp: 1
    )
    
    var body: some View {
        ScrollView(.vertical){
            LazyVStack {
                
       CastCardView(cast: data)
       CastCardView(cast: data)
       CastCardView(cast: data)
            }
        }
    }
}

#Preview {
    ContentView()
}
