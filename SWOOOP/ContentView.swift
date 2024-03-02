//
//  ContentView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ContentView: View {
    @State public var casts: [Cast] = []
    
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
                CastCardView(cast: cast)
            }
        }
        .scrollTargetBehavior(.paging)
        .onAppear { loadCasts() }
    }
}

#Preview {
    ContentView()
}
