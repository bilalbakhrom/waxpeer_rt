//
//  AUIScrollOffset.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI

public struct AUIScrollViewWithOffset<Content: View>: View {
    @Binding public var scrollOffset: CGPoint
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let coordinateSpaceName = "ScrollViewOffset"
    private let content: Content
    
    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, scrollOffset: Binding<CGPoint>, content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self._scrollOffset = scrollOffset
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
                .scrollOffset(
                    coordinateSpaceName: coordinateSpaceName,
                    offset: $scrollOffset
                )
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

public struct AUIScrollOffset: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

extension View {
    public func scrollOffset(coordinateSpaceName: String, offset: Binding<CGPoint>) -> some View {
        self.background(
            GeometryReader { geometry in
                let value = geometry.frame(in: .named(coordinateSpaceName)).origin
                Color.clear
                    .preference(key: AUIScrollOffset.self, value: value)
            }
        )
        .onPreferenceChange(AUIScrollOffset.self) { value in
            offset.wrappedValue = value
        }
    }
}
