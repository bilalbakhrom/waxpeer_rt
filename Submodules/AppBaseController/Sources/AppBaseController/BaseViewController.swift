//
//  BaseViewController.swift
//
//
//  Created by Bilal Bakhrom on 2024-01-07.
//

import SwiftUI
import Combine
import AppNetwork

/// A base view controller class with common functionalities.
open class BaseViewController: NiblessViewController {
    // MARK: - Properties
    
    // MARK: Private Stored Properties
    
    /// Set of Combine cancellables for managing subscriptions.
    public var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initializes a `BaseViewController` instance.
    public init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    // MARK: - Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNavigationBarBackground(to: .clear)
        bind()
    }
    
    // MARK: - BINDERS
    
    open func bind() {}
    
    open func didClickBackButton() {}
    
    // MARK: - Network
    
    /// Performs initial network requests asynchronously.
    open func performInitialRequests() async {}
    
    // MARK: - Layout
    
    /// Sets up subviews by embedding and activating constraints.
    open func setupSubviews() {
        embedSubviews()
        activateSubviewsConstraints()
    }
    
    /// Embeds subviews into the view.
    open func embedSubviews() {}
    
    /// Activates constraints for subviews.
    open func activateSubviewsConstraints() {}
}

// MARK: - NAVIGATION BAR CONTROL

extension BaseViewController {
    /// Updates the navigation bar background color.
    public func updateNavigationBarBackground(to color: UIColor?) {
        let appearance = UINavigationBarAppearance()
        
        // Configure appearance based on the provided color.
        color == .clear
        ? appearance.configureWithTransparentBackground()
        : appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        // Apply appearance to different navigation bar states.
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
    }
    
    /// Sets the navigation bar title with the given string.
    public func setNavigationBar(title: String, subtitle: String? = nil) {
        let label = UILabel()
        label.textColor = .label
        label.text = title
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.sizeToFit()
        
        if let subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.textColor = .secondaryLabel
            subtitleLabel.text = subtitle
            subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
            subtitleLabel.sizeToFit()
            
            let vStack = UIStackView(arrangedSubviews: [label, subtitleLabel])
            vStack.axis = .vertical
            vStack.alignment = .center
                        
            navigationItem.titleView = vStack
        } else {
            navigationItem.titleView = label
        }
    }
    
    /// Shows the navigation bar.
    public func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// Hides the navigation bar.
    public func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    private func handleBackButtonClick() {
        didClickBackButton()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NAVIGATION STACK CONTROL

extension BaseViewController {
    /// Removes the previous screen from the navigation stack.
    public func removePreviousScreen() {
        guard let navigationController = navigationController, navigationController.viewControllers.count >= 2 else { return }
        
        let index = navigationController.viewControllers.count - 2
        navigationController.viewControllers.remove(at: index)
    }
    
    /// Removes the previous screen of a specific type from the navigation stack.
    public func removePreviousScreen<T: UIViewController>(ofType type: T.Type) {
        guard let navigationController = navigationController, navigationController.viewControllers.count >= 2,
              let index = navigationController.viewControllers.firstIndex(where: { $0.isKind(of: type) }) else { return }
        
        navigationController.viewControllers.remove(at: index)
    }
}

extension BaseViewController {
    public func showError(with content: ANErrorContent?) {
        guard let content else { return }
        
        let alertController = UIAlertController(
            title: content.errorTitle,
            message: content.errorDescription,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alertController, animated: true)
    }
}
