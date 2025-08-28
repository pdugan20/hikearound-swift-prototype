//
//  HikeMarkerView.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct HikeMarkerView: View {
    let hike: Hike
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.thinMaterial)
                .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                .overlay {
                    Circle()
                        .strokeBorder(Color.accentColor, lineWidth: isSelected ? 3 : 2)
                }
            
            Image(systemName: "figure.hiking")
                .font(.system(size: isSelected ? 20 : 16, weight: .bold))
                .foregroundStyle(Color.accentColor)
        }
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.bouncy, value: isSelected)
    }
}

#Preview {
    VStack(spacing: 20) {
        HikeMarkerView(hike: Hike.sampleHikes[0], isSelected: false)
        HikeMarkerView(hike: Hike.sampleHikes[1], isSelected: true)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}