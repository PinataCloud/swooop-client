//
//  ContentView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State public var casts: [Cast] = []
    @State public var isProfileViewPresented = false 
    @State public var isCastFormViewPresented = false
    @State public var selectedChannel: Channel = Channel(name: "Pinata", url: "https://warpcast.com/~/channel/pinata")
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
    
    func toggleCastFormView(){
        isCastFormViewPresented.toggle()
    }

    func loadCasts(channel: Channel) {
        casts = []
        print("Loading: ")
        print(channel)
        selectedChannel = channel
        CastManager.shared.fetchCasts(channel: channel.url) { result in
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
                .padding(.bottom, -20)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(channels, id: \.url) { channel in
                        VStack{
                            Text(channel.name).padding(.top, 40)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(red: 0.431, green: 0.988, blue: 1), Color(red: 0.867, green: 0.435, blue: 1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .font(Font.custom("Chillax-Bold", size: 26, relativeTo: .title))
                                .bold()
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                    ForEach(casts, id: \.id) { cast in
                                        ZStack{
                                            CastCardView(cast: cast)
                                                .containerRelativeFrame([.horizontal, .vertical])
                                                .padding(.horizontal, 20)
                                                .background(Color(red: 0.071, green: 0.071, blue: 0.071))
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .onAppear { loadCasts(channel: channel) }
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
            .ignoresSafeArea()
            .background(
                Color(red: 0.11, green: 0.11, blue: 0.118)
            )
            .sheet(isPresented: $isProfileViewPresented) {
                ProfileView(toggleProfileView: toggleProfileView)
            }
            .sheet(isPresented: $isCastFormViewPresented){
                CastFormView(toggleCastFormView: toggleCastFormView, channel: selectedChannel)
            }
            .overlay(
                GeometryReader { geometry in
                    Button(action: {
                        toggleCastFormView()
                    }) {
                        Image("button") // Replace with your button's content
                            .font(.largeTitle)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .padding(.horizontal)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottomTrailing)
                }
            )
        }
        .background(Color(red: 0.071, green: 0.071, blue: 0.071))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
