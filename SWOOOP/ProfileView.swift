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
                if let signer_private = KeyValueStore.shared.value(forKey: "signer_private") as? String {
                    print("Signer: \(signer_private)")
                } else {
                    print("signer_private not found")
                }
            case .failure(let error):
                // Handle error
                print(error)
            }
        }
    }
    
    func signIn() {
        poll(token: "0x65ecbd1a9f61a8fa8ac76e15")
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
        Image("bg")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all) // Fill the entire screen
            .overlay(
                VStack(alignment: .center) {
                    if(userProfile.username != "") {
                            AsyncImage(url: URL(string: userProfile.pfp)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                        .padding()
                                    
                                } else if phase.error != nil {
                                    Text("Failed to load image")
                                } else {
                                    ProgressView()
                                }
                            }
                            Text(userProfile.username)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                        Text(String(userProfile.fid))
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    } else {
                        Button(action: signIn) {
                            Text("Sign in with Warpcast")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                    }
                }.onAppear {
                    loadUser()
                }
                    .padding(.top, 200)
                    .background(.clear)
            )
    }
}

#Preview {
    ProfileView()
}
