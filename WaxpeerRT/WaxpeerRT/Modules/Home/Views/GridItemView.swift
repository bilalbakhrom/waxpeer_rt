//
//  GridItemView.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI
import AppColors
import AppNetwork

struct GameItemView: View {
    let item: GameItem
    var onAddToCart: (() -> Void)?
    var onBuy: (() -> Void)?
    
    private let buttonCornerRadius: CGFloat = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(item.iconName)
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    Text(item.game.uppercased())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.modulePrimaryLabel)
                        .opacity(0.8)
                }
                
                Text(item.name)
                    .lineLimit(2)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.modulePrimaryLabel)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: .zero)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: .zero) {
                    Text("$\(item.price)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.modulePrimaryLabel)
                    
                    Spacer(minLength: .zero)
                }
                
                HStack(spacing: 16) {
                    Button {
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                            
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.modulePrimaryLabel)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(.rect(cornerRadius: buttonCornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .inset(by: 0.25)
                                .stroke(Color.gray, lineWidth: 0.5)
                        }
                    }
                    .frame(width: 32, height: 32)
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(Color.accentColor)
                            
                            Text("Buy now")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .clipShape(.rect(cornerRadius: buttonCornerRadius))
                    }
                }
            }
        }
        .padding(12)
        .background(Color.moduleSecondaryBackground)
        .frame(maxHeight: .infinity)
        .clipShape(.rect(cornerRadius: 12))
    }
}
