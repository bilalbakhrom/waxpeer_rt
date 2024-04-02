//
//  BaseViewModel.swift
//
//
//  Created by Bilal Bakhrom on 2024-01-07.
//

import Foundation
import Combine
import AppNetwork

/// A base view model class that provides error handling functionality.
open class BaseViewModel: ObservableObject {
    private var errorSubject = PassthroughSubject<ANErrorContent?, Never>()
    
    /// Publisher to observe errors within the view model.
    public var errorPublisher: AnyPublisher<ANErrorContent?, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    public init() {}
}

// MARK: - ERROR

extension BaseViewModel {
    /// Reports an error to the view model.
    ///
    /// If the provided error is of type `ANError`, it is handled internally;
    /// otherwise, a default `ANErrorContent` is sent through the error subject.
    ///
    /// - Parameter error: The error to be reported.
    public func reportError(_ error: Error?) {
        if let customError = error as? ANError {
            handleANError(customError)
        } else {
            errorSubject.send(ANErrorContent())
        }
    }
    
    /// Handles errors of type `ANError` internally.
    ///
    /// - Parameter anError: The ANError to be handled.
    private func handleANError(_ anError: ANError) {
        switch anError {
        case .serverError:
            errorSubject.send(ANErrorContent())
            
        case .clientError(let content):
            errorSubject.send(content)
        }
    }
}
