//
//  ANErrorContent.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

public struct ANErrorContentWrapper: Codable {
    public var error: ANErrorContent
}

/// A structure representing the content of an error in the application.
public struct ANErrorContent: Codable {
    /// The general error title.
    public var title: String?
    
    /// The general error message.
    public var message: String?
    
    public init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
}

// MARK: - EXTENSIONS

extension ANErrorContent {
    /// A user-friendly title summarizing the main error content.
    ///
    /// If the specific error type is available, the title will include it as "Error: [error]".
    /// If not, it defaults to "Unknown Error".
    public var errorTitle: String {
        if let title { return title }
        else { return "Something went wrong" }
    }
    
    /// A user-friendly description providing details about the error.
    ///
    /// It prioritizes the general error message (`message`) and falls back to detailed
    /// error message (`details?.errorMessage`). If both are unavailable, a default message
    /// "An unexpected error occurred." is provided.
    public var errorDescription: String {
        if let message = message {
            return message
        } else {
            return "An unexpected error occurred. Please, try again."
        }
    }
}

// MARK: - CODING KEYS

extension ANErrorContent {
    enum CodingKeys: CodingKey {
        case message
    }
}
