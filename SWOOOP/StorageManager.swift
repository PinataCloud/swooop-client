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
}

