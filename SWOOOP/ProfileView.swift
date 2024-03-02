//
//  ProfileView.swift
//  SWOOOP
//
//  Created by Steve Simkins on 3/2/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var userProfile: User = User(fid: 0, username: "", pfp: "")
    @State private var deepLinkUrl: String = ""
    func loadUser() {
        let user = UserManager.shared.getUserData()
        if(user?.username != nil) {
            userProfile = user ?? User(fid: 0, username: "", pfp: "")
        }
    }
    
    func poll(token: String) {
        UserManager.shared.pollForSuccess(token: token) { result in
            switch result {
            case .success(let complete):
                print("close the sheet")
            case .failure(let error):
                // Handle error
                print(error)
            }
        }
    }
    
    func signIn() {
        poll(token: "0x24491821d0f60ba0e48d9952")
//        UserManager.shared.signIn { result in
//            switch result {
//            case .success(let signerPayload):
//                // Use signerPayload
//                print(signerPayload)
//                poll(token: signerPayload.pollingToken)
//                deepLinkUrl = signerPayload.deepLinkUrl
//                openURL()
//            case .failure(let error):
//                // Handle error
//                print(error)
//            }
//        }
    }
    
    func openURL() {
        if let url = URL(string: deepLinkUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        VStack {
            if(userProfile.username != "") {
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: userProfile.pfp)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 42, height: 42)
                                .clipShape(Circle())
                                .padding()
                            
                        } else if phase.error != nil {
                            Text("Failed to load image")
                        } else {
                            ProgressView()
                        }
                    }
                    Text(userProfile.username)
                }
                Text(String(userProfile.fid))
            } else {
                Button(action: signIn) {
                                Text("Sign in with Warpcast")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(10)
                            }
                Text("Swipe your face off")
            }
        }.onAppear {
            loadUser()
        }
    }
}

#Preview {
    ProfileView()
}
