//
//  ChannelSelectorView.swift
//  SWOOOP
//
//  Created by Justin Hunter on 3/4/24.
//

import SwiftUI

struct Channel {
    let name: String
    let url: String
}

struct ChannelSelectorView: View {
    @State public var selected: String = "Pinata"
    let channels: [Channel] = [
            Channel(name: "Pinata", url: "https://warpcast.com/~/channel/pinata"),
            Channel(name: "Ted", url: "https://warpcast.com/~/channel/ted"),
            Channel(name: "Diet Coke", url: "https://warpcast.com/~/channel/diet-coke"),
            Channel(name: "Memes", url: "chain://eip155:1/erc721:0xfd8427165df67df6d7fd689ae67c8ebf56d9ca61"),
            Channel(name: "Base", url: "https://onchainsummer.xyz"),
            Channel(name: "Founders", url: "https://farcaster.group/founders"),
            // Add more channels as needed
        ]
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(channels, id: \.url) { channel in
                            ChannelView(channel: channel, selected: selected)
                        }
                    }
                    .padding()
                    .frame(width: contentWidth(geometry: geometry), height: 20, alignment: .leading)
                }
            }
        }.background(.clear)
            .frame(height: 20)
        
    }
    
    private func contentWidth(geometry: GeometryProxy) -> CGFloat {
        let width = CGFloat(channels.count) * 150 + CGFloat((channels.count - 1) * 10) // total width of all channels plus spacing
        return max(width, geometry.size.width) // ensure content width is at least the width of the screen
    }
}

struct ChannelView: View {
    let channel: Channel
    let selected: String
    
    var body: some View {
        VStack {
            Text(channel.name)
                .font(Font.custom("Chillax-Bold", size: 18))
                .foregroundColor(.clear)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                        .mask(Text(channel.name).padding().frame(width: 150, height: 20).font(Font.custom("Chillax-Bold", size: 18)))
                )
        }
        .padding()
    }
}

#Preview {
    ChannelSelectorView()
}
