//
//  UserManager.swift
//  SWOOOP
//
//  Created by Justin Hunter on 3/1/24.
//

import Foundation

struct User: Codable {
    let fid: Int
    let username: String
    let pfp: String
}

struct SignerPayload: Codable {
    let pollingToken: String
    let privateKey: String
    let publicKey: String
    let deepLinkUrl: String
}

struct Completion: Codable {
    let state: String
    let userFid: Int
}

class UserManager {
    static let shared = UserManager()
    
    func getUserData() -> User? {
        var user_name: String = ""
        var user_fid: String = ""
        var user_pfp: String = ""
        if let username = KeyValueStore.shared.value(forKey: "username") as? String {
            user_name = username
        } else {
            print("username not found")
        }
        
        if let fid = KeyValueStore.shared.value(forKey: "fid") as? String {
            user_fid = fid
        } else {
            print("fid not found")
        }
        
        if let pfp = KeyValueStore.shared.value(forKey: "pfp") as? String {
            user_pfp = pfp
        } else {
            print("pfp not found")
        }
        
        if(user_fid != "" && user_pfp != "" && user_name != "") {
            let newUser = User(fid: Int(user_fid)!, username: user_name, pfp: user_pfp)
            return newUser
        }
        
        return User(fid: 0, username: "", pfp: "")
    }
    
    func fetchUser(fid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let urlString = "https://your-api-endpoint.com/user?fid=\(fid)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create URLSessionDataTask to make the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for response status code
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Check if data is available
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Decode the JSON response into the User struct
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func pollForSuccess(token: String, completion: @escaping (Result<Completion, Error>) -> Void) {
        print("We polling...")
        let urlString = "https://swooop-server.onrender.com/sign-in/poll?pollingToken=\(token)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create URLSessionDataTask to make the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for response status code
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            // Check if data is available
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let complete = try JSONDecoder().decode(Completion.self, from: data)
                let status: String = complete.state
                print(status)
                if (status == "completed") {
                    KeyValueStore.shared.setValue(String(complete.userFid), forKey: "fid")
//                    self.fetchUser(fid: String(complete.userFid)) { result in
//                        switch result {
//                        case .success(let user):
//                            print(user)
//                            KeyValueStore.shared.setValue(user.username, forKey: "username")
//                            KeyValueStore.shared.setValue(user.pfp, forKey: "pfp")
//                        case .failure(let error):
//                            // Handle error
//                            print("Error: \(error)")
//                        }
//                    }
                    print("WE MADE IT")
                    KeyValueStore.shared.setValue("true", forKey: "signer_approved")
                    completion(.success(complete))
                } else {
                    self.pollForSuccess(token: token, completion: completion)
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func signIn(completion: @escaping (Result<SignerPayload, Error>) -> Void) {
        print("Signing in...")
        let url = URL(string: "https://d5db-65-144-97-186.ngrok-free.app/sign-in")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for HTTP response status code indicating success
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])))
                return
            }
            
            // Ensure data is present
            guard let responseData = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                // Decode the JSON response into a SignerPayload object
                let decoder = JSONDecoder()
                let signerPayload = try decoder.decode(SignerPayload.self, from: responseData)
                print("Signer payload")
                print(signerPayload)
                KeyValueStore.shared.setValue(signerPayload.privateKey, forKey: "signer_private")
                KeyValueStore.shared.setValue("false", forKey: "signer_approved")
                KeyValueStore.shared.setValue(signerPayload.pollingToken, forKey: "polling_token")
                completion(.success(signerPayload))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

