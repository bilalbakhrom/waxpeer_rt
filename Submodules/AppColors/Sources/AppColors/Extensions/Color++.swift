//
//  Color++.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI

extension Color {
    public static var modulePrimaryBackground: Color {
        Color("AppPrimaryBackground", bundle: .module)
    }
    
    public static var modulePrimaryLabel: Color {
        Color("AppPrimaryLabel", bundle: .module)
    }
    
    public static var moduleSecondaryBackground: Color {
        Color("AppSecondaryBackground", bundle: .module)
    }
    
    public static var moduleSecondaryLabel: Color {
        Color("AppSecondaryLabel", bundle: .module)
    }
}

extension UIColor {
    public static var modulePrimaryBackground: UIColor {
        fetchColor("AppPrimaryBackground")
    }
    
    public static var modulePrimaryLabel: UIColor {
        fetchColor("AppPrimaryLabel")
    }
    
    public static var moduleSecondaryBackground: UIColor {
        fetchColor("AppSecondaryBackground")
    }
    
    public static var moduleSecondaryLabel: UIColor {
        fetchColor("AppSecondaryLabel")
    }
}

extension UIColor {
    private static func fetchColor(_ name: String) -> UIColor {
        guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
            fatalError("Failed to load color named \(name)")
        }
        
        return color
    }
}
