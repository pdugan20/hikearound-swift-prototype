//
//  HikeDetailSheet.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct HikeDetailSheet: View {
    let hike: Hike
    let onDismiss: () -> Void
    @State private var showFullDetails = false
    
    var formattedTime: String {
        let hours = Int(hike.estimatedTime) / 3600
        let minutes = Int(hike.estimatedTime) % 3600 / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(hike.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 12) {
                            Label(hike.difficulty.rawValue, systemImage: "figure.hiking")
                                .font(.subheadline)
                                .foregroundStyle(hike.difficulty.color)
                            
                            Label("\(String(format: "%.1f", hike.distance)) mi", systemImage: "map")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 48, height: 48)
                            .glassEffect(in: .circle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 32)
                
                // Details
                VStack(alignment: .leading, spacing: 16) {
                    Text(hike.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(showFullDetails ? nil : 2)
                        .padding(.horizontal)
                        .padding(.top, 12)
                    
                    // Stats Grid
                    HStack(spacing: 20) {
                        StatView(icon: "arrow.up.forward", title: "Elevation", value: "\(Int(hike.elevationGain)) ft")
                        StatView(icon: "clock", title: "Duration", value: formattedTime)
                        StatView(icon: "location", title: "Distance", value: "\(String(format: "%.1f", hike.distance)) mi")
                    }
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button {
                            // Start navigation
                        } label: {
                            Label("Directions", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            // Save hike
                        } label: {
                            Label("Save", systemImage: "bookmark")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            Rectangle()
                .fill(.regularMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            withAnimation {
                showFullDetails.toggle()
            }
        }
    }
}

#Preview {
    HikeDetailSheet(hike: Hike.sampleHikes[0]) {
        // Dismiss action
    }
}