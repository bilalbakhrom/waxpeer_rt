//
//  HomeView.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI
import AppColors
import AppUIKit

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    }
    
    private var canScrollToTop: Bool {
        viewModel.scrollOffset.y < -20
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.modulePrimaryBackground)
            
            if viewModel.debouncedItems.isEmpty {
                placeholder
            } else {
                content
            }
            
            connectionButton
            
            gradientView
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var placeholder: some View {
        EmptyView()
    }
    
    private var content: some View {
        ScrollViewReader { proxy in
            AUIScrollViewWithOffset(scrollOffset: $viewModel.scrollOffset) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.debouncedItems) { item in
                        GameItemView(item: item)
                            .frame(height: 180)
                            .id(item.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 80)
            }
            .padding(.top, 12)
            .animation(.linear(duration: 0.15), value: viewModel.debouncedItems)
            .onReceive(viewModel.scrollToTopPublisher) { _ in
                proxy.scrollTo(viewModel.debouncedItems.first?.id, anchor: .top)
            }
        }
    }
    
    private var connectionButton: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            HStack(spacing: .zero) {
                Spacer()
                
                VStack(spacing: 12) {
                    if canScrollToTop {
                        Button {
                            Task { await viewModel.onViewEvent(.scrollContentToTop) }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 28)
                                    .fill(Color.gray)
                                    .frame(width: 28, height: 28)
                                
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color.modulePrimaryLabel)
                            }
                            .frame(width: 28, height: 28)
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity.combined(with: .scale))
                    }
                    
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        Task { await viewModel.onViewEvent(viewModel.isConnected ? .disconnect : .connect) }
                    } label: {
                        Image(systemName: "livephoto")
                            .font(.system(size: 40))
                    }
                    .frame(width: 48, height: 48)
                    .buttonStyle(ConnectionButtonStyle(activeColor: .green, deactiveColor: .gray))
                    .connected(viewModel.isConnected)
                }
            }
        }
        .padding(16)
        .padding(.bottom, 44)
        .animation(.easeInOut, value: viewModel.isAutoConnectEnabled)
    }
    
    private var gradientView: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            LinearGradient(
                colors: [
                    Color.modulePrimaryBackground,
                    Color.modulePrimaryBackground.opacity(0.8),
                    Color.clear
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            .frame(height: 60)
        }
    }
}
