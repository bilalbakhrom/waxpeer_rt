//
//  HomeView.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI
import AppColors

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
            
            if viewModel.items.isEmpty {
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
                ForEach(viewModel.items) { item in
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
                    ZStack {
                        Rectangle()
                            .fill(viewModel.isConnected ? Color.green : Color.gray)
                        
                        Image(systemName: "livephoto")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(.rect(cornerRadius: 48))
                }
            }
        }
        .padding(16)
    }
}
