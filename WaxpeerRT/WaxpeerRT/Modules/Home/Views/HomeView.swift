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
        }
    }
    
    private var placeholder: some View {
        EmptyView()
    }
    
    private var content: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.debouncedItems) { item in
                    GameItemView(item: item)
                        .frame(height: 180)
                        .id(item.id)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var connectionButton: some View {
        VStack(spacing: .zero) {
            Spacer()
            
            HStack(spacing: .zero) {
                Spacer()
                
                Button {
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
        .padding(16)
    }
}
