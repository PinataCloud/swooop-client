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
    let deepLinkURL: String
    let fid: String
}

struct Completion: Codable {
    let status: String
}

class UserManager {
    static let shared = UserManager()
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
        let urlString = "https://your-api-endpoint.com/user?token=\(token)"
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
                let status: String = complete.status
                if (status == "complete") {
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
        let url = URL(string: "https://example.com/api/endpoint")!
        
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
                KeyValueStore.shared.setValue(signerPayload.privateKey, forKey: "signer_private")
                KeyValueStore.shared.setValue("false", forKey: "signer_approved")
                KeyValueStore.shared.setValue(signerPayload.fid, forKey: "fid")
                self.fetchUser(fid: signerPayload.fid) { result in
                    switch result {
                    case .success(let user):
                        print(user)
                        KeyValueStore.shared.setValue(user.username, forKey: "username")
                        KeyValueStore.shared.setValue(user.pfp, forKey: "pfp")
                    case .failure(let error):
                        // Handle error
                        print("Error: \(error)")
                    }
                }
                completion(.success(signerPayload))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

