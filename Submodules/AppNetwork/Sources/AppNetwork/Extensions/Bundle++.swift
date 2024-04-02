//
//  Bundle++.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

extension Bundle {
    var socketKey: String? {
        guard let path = path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = configDict["API_KEY"] as? String
        else {
            return nil
        }
        
        return apiKey
    }
}
