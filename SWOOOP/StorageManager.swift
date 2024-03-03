//
//  StorageManager.swift
//  SWOOOP
//
//  Created by Justin Hunter on 3/1/24.
//

import Foundation

class KeyValueStore {
    static let shared = KeyValueStore()
    
    private init() {}
    
    // Function to store key-value pair
    func setValue(_ value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // Function to fetch value for a given key
    func value(forKey key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    func removeValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}


// Storing a value
//KeyValueStore.shared.setValue("0x...", forKey: "signer_private")
//KeyValueStore.shared.setValue("0x...", forKey: "signer_public")
//KeyValueStore.shared.setValue("4823", forKey: "fid")

// Fetching a value
//if let signer_private = KeyValueStore.shared.value(forKey: "signer_private") as? String {
//    print("Signer: \(signer_private)")
//} else {
//    print("signer_private not found")
//}

