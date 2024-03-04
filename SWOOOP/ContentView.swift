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
    @State public var isCastFormViewPresented = false // Track if the profile view is presented
    
    func toggleProfileView() {
        isProfileViewPresented.toggle()
    }
    
    func toggleCastFormView(){
        isCastFormViewPresented.toggle()
    }
    func loadCasts() {
        CastManager.shared.fetchCasts() { result in
                    switch result {
                    case .success(let casts):
                        // Do something with the fetched posts
                        print(casts)
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
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(casts, id: \.id) { cast in
                        ZStack {
                            CastCardView(cast: cast)
                                .containerRelativeFrame([.horizontal, .vertical])
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .onAppear { loadCasts() }
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .background(
                Color(red: 0.11, green: 0.11, blue: 0.118)
            )
            .sheet(isPresented: $isProfileViewPresented) {
                ProfileView(toggleProfileView: toggleProfileView)
            }
            .sheet(isPresented: $isCastFormViewPresented){
                CastFormView()
            }
            .overlay(
                GeometryReader { geometry in
                    Button(action: {
                        toggleCastFormView()
                    }) {
                        Image(systemName: "plus") // Replace with your button's content
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
    }
}

#Preview {
    ContentView()
}
