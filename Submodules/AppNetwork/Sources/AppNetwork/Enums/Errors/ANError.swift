//
//  ANError.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

public enum ANError: Error {
    case serverError(statusCode: Int)
    case clientError(content: ANErrorContent)
}
