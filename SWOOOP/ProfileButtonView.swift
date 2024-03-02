//
//  ProfileButtonView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ProfileButtonView: View {
    @State private var userProfile: User = User(fid: 0, username: "", pfp: "")
    func loadUser() {
        let user = UserManager.shared.getUserData()
        if(user?.username != nil) {
            userProfile = user ?? User(fid: 0, username: "", pfp: "")
        }
    }
    //var cast: Cast
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            if(userProfile.username != "") {
                AsyncImage(url: URL(string: userProfile.pfp)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, height: 42)
                            .clipShape(Circle())
                            .padding()
                        
                    } else if phase.error != nil {
                        Text("Could not fetch image")
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 0.11, green: 0.11, blue: 0.118)
        )
        .onAppear {
            loadUser()
        }
    }
    
}
