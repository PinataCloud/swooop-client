//
//  CastManager.swift
//  SWOOOP
//
//  Created by Justin Hunter on 3/1/24.
//

import Foundation

struct Embed: Codable {
    let type: String
    let url: String
}

struct Cast: Codable {
    let id: Int
    let castText: String
    let embeds: [Embed]
    let username: String
    let pfp: String
    let timestamp: Int
}

class CastManager {
    static let shared = CastManager()
    
    var casts: [Cast] = []
    
    func fetchCasts(completion: @escaping (Result<[Cast], Error>) -> Void) {
        // Replace "https://api.swooop.com/casts" with your actual API endpoint
        guard let url = URL(string: "https://api.swooop.com/casts") else {
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
    
    func postCast(text: String) {
        //  @TODO we need a helper function to look up the signer and FID in device storage and pass it in to the body
        let url = URL(string: "https://example.com/api/endpoint")!

        let jsonData = """
        {
            "signer": "value1",
            "castMessage": "value2",
            "fid": "value3",
            "parentUrl": ""
        }
        """.data(using: .utf8)

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

        // Start the task
        task.resume()

    }
}

