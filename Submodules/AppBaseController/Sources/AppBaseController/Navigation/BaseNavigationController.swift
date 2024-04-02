//
//  BaseNavigationController.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import UIKit

open class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
}

