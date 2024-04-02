//
//  AUICircularPulseAnimation.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI

public struct AUICircularPulseAnimation: View {
    private let color: Color
    
    @State private var animate = false
    
    public init(color: Color = .accentColor) {
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.height
            VStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.25))
                        .frame(width: size, height: size)
                        .scaleEffect(animate ? 1.5 : 1)
                    
                    Circle()
                        .fill(color.opacity(0.35))
                        .frame(width: size * 0.8, height: size * 0.8)
                        .scaleEffect(animate ? 1.5 : 1)
                    
                    Circle()
                        .fill(color.opacity(0.45))
                        .frame(width: size * 0.5, height: size * 0.5)
                        .scaleEffect(animate ? 1.5 : 1)
                    
                    Circle()
                        .fill(color)
                        .frame(width: size * 0.2, height: size * 0.2)
                }
                .animation(
                    .linear(duration: 0.9).repeatForever(autoreverses: true),
                    value: animate
                )
                .onAppear { animate = true }
            }
            .frame(width: size, height: size)
        }
    }
}
