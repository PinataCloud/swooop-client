//
//  ContentView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State public var casts: [Cast] = []
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.purple.cgColor,
            UIColor.cyan.cgColor
        ]
        gradient.locations = [0, 0.25, 1]
        return gradient
    }()
    
    
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
        
        ScrollView(.vertical){
            ForEach(casts, id: \.id) { cast in
                CastCardView(cast: cast, screenHeight: UIScreen.main.bounds.height)
            }
        }
        .scrollTargetBehavior(.paging)
        .ignoresSafeArea(.all)
        .onAppear { loadCasts() }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.522, green: 0.267, blue: 0.608), Color(red: 0.341, green: 0.741, blue: 0.753)]), startPoint: .bottom, endPoint: .top)
        )
    }
}

#Preview {
    ContentView()
}
