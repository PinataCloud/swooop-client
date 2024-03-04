//
//  ProfileButtonView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/1/24.
//

import SwiftUI

struct ProfileButtonView: View {
    @State private var userProfile: User = User(fid: 0, username: "", pfp: "https://dweb.mypinata.cloud/ipfs/QmebfRyBCYe3UraZjLESoRzqA154oqYDp1Er1V8EETvy2r")
    var toggleProfileView: () -> Void
    func loadUser() {
        let user = UserManager.shared.getUserData() ?? User(fid: 0, username: "", pfp: "https://dweb.mypinata.cloud/ipfs/QmebfRyBCYe3UraZjLESoRzqA154oqYDp1Er1V8EETvy2r")
        userProfile = user
        print("User Profile: ")
        print(userProfile)
    }
    //var cast: Cast
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            AsyncImage(url: URL(string: userProfile.pfp)) { phase in
                if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                } else if phase.error != nil {
                    Image(systemName: "person.crop.circle.fill") // Use a default image if loading fails
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .padding()
                } else {
                    ProgressView()
                }
            }.onTapGesture {
                self.toggleProfileView()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.071, green: 0.071, blue: 0.071))
        .onAppear {
            loadUser()
        }
        .padding(0)
    }
    
}
