//
//  ContentView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State public var casts: [Cast] = []
    @State public var isProfileViewPresented = false // Track if the profile view is presented
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
    
    func toggleProfileView() {
        isProfileViewPresented.toggle()
    }
    func loadCasts(channel: String) {
        casts = []
        print("Loading: ")
        print(channel)
        CastManager.shared.fetchCasts(channel: channel) { result in
                    switch result {
                    case .success(let casts):
                        // Do something with the fetched posts
                        self.casts = casts
                    case .failure(let error):
                        // Handle error
                        print("Failed to fetch casts: \(error)")
                    }
                }
    }
    
    var body: some View {
        NavigationStack {
            ProfileButtonView(toggleProfileView: toggleProfileView)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(channels, id: \.url) { channel in
                        VStack{
                            Text(channel.name).padding(.top, 40)
                                .foregroundColor(.white)
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                    ForEach(casts, id: \.id) { cast in
                                        ZStack {
                                            CastCardView(cast: cast)
                                                .containerRelativeFrame([.horizontal, .vertical])
                                                .padding(.horizontal, 20)
                                                .background(Color(red: 0.071, green: 0.071, blue: 0.071))
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .onAppear { loadCasts(channel: channel.url) }
                            .scrollTargetBehavior(.paging)
                            .ignoresSafeArea()
                            .background(
                                Color(red: 0.11, green: 0.11, blue: 0.118)
                            )
                            .sheet(isPresented: $isProfileViewPresented) {
                                ProfileView(toggleProfileView: toggleProfileView)
                            }
                            .containerRelativeFrame([.horizontal, .vertical])
                            .padding(0)
                            .background(Color(red: 0.071, green: 0.071, blue: 0.071))
                        }.background(Color(red: 0.071, green: 0.071, blue: 0.071))
                    }
                    .background(Color(red: 0.071, green: 0.071, blue: 0.071))
                }
                .background(Color(red: 0.071, green: 0.071, blue: 0.071))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .scrollTargetBehavior(.paging)
            .background(Color(red: 0.071, green: 0.071, blue: 0.071))
        }
        .background(Color(red: 0.071, green: 0.071, blue: 0.071))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
