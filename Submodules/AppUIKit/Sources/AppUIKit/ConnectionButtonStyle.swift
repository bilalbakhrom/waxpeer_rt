//
//  ConnectionButtonStyle.swift
//  
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI
import AppColors

public struct ConnectionButtonStyle: ButtonStyle {
    public let activeColor: Color
    public let deactiveColor: Color
    
    @Environment(\.isConnected) private var isConnected
    
    public init(activeColor: Color, deactiveColor: Color) {
        self.activeColor = activeColor
        self.deactiveColor = deactiveColor
    }
        
    public func makeBody(configuration: Configuration) -> some View {
        GeometryReader { proxy in
            ZStack {
                if isConnected {
                    RoundedRectangle(cornerRadius: proxy.size.height)
                        .fill(Color.green)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    RoundedRectangle(cornerRadius: proxy.size.height)
                        .fill(Color.gray)
                }
                
                configuration.label
                    .foregroundColor(.white)
            }
            .clipShape(.rect(cornerRadius: proxy.size.height))
            .animation(.easeInOut, value: isConnected)
        }
    }
}

fileprivate struct ConnectionButtonStateEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

fileprivate extension EnvironmentValues {
    var isConnected: Bool {
        get { self[ConnectionButtonStateEnvironmentKey.self] }
        set { self[ConnectionButtonStateEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func connected(_ isConnected: Bool) -> some View {
        self.environment(\.isConnected, isConnected)
    }
}
