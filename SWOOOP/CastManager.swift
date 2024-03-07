//
//  CastManager.swift
//  SWOOOP
//
//  Created by Justin Hunter on 3/1/24.
//

import Foundation

struct CastId: Codable {
    let fid: Int
    let hash: String
}

struct EmbedCast: Codable {
    let castId: CastId
}

struct EmbedUrl: Codable {
    let url: String
}



struct Cast: Codable {
    let id: String
    let castText: String
    let embedUrl: [EmbedUrl]
    let embedCast: [EmbedCast]
    let username: String
    let pfp: String
    let timestamp: String
    let likes: Int
    let recasts: Int
}

struct PostBody: Codable {
    let signer: String
    let castMessage: String
    let fid: String
    let parentUrl: String
}

class CastManager {
    static let shared = CastManager()
    
    var casts: [Cast] = []
    
    func fetchCasts(channel: String, completion: @escaping (Result<[Cast], Error>) -> Void) {
        guard let url = URL(string: "https://swooop-server.onrender.com/feed?channel=\(channel)&pageToken=blank") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Cast].self, from: data)
                self.casts = decodedData
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func postCast(text: String, parentUrl: String) { 
        var user_fid: String = ""
        var user_signer: String = ""
        if let fid = KeyValueStore.shared.value(forKey: "fid") as? String {
            print("fid: \(fid)")
            user_fid = fid
        } else {
            print("fid not found")
        }
        
        if let signer_private = KeyValueStore.shared.value(forKey: "signer_private") as? String {
            print("signer_private: \(signer_private)")
            user_signer = signer_private
        } else {
            print("signer_private not found")
        }
        let url = URL(string: "https://swooop-server.onrender.com/message")!
        
        let postBody = PostBody(signer: user_signer,
                                castMessage: text,
                                fid: user_fid,
                                parentUrl: parentUrl)

        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(postBody)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                var request = URLRequest(url: url)

                request.httpMethod = "POST"

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                request.httpBody = jsonData

                let session = URLSession.shared

                let task = session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data returned")
                        return
                    }
                    
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }

                task.resume()

            }
        } catch {
            print("Error encoding PostBody to JSON:", error)
        }
    }
}

