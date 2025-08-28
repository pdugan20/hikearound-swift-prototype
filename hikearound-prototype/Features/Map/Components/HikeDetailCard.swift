//
//  HikeDetailCard.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct HikeDetailCard: View {
    let hike: Hike
    @Binding var isPresented: Bool
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
        VStack(spacing: 0) {
            // Drag indicator
            Capsule()
                .fill(.quaternary)
                .frame(width: 36, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(hike.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        Label(hike.difficulty.rawValue, systemImage: "figure.hiking")
                            .font(.subheadline)
                            .foregroundStyle(Color(hike.difficulty.color))
                        
                        Label("\(String(format: "%.1f", hike.distance)) mi", systemImage: "map")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    onDismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            
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
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -5)
        .padding(.horizontal)
        .padding(.bottom)
        .onTapGesture {
            withAnimation {
                showFullDetails.toggle()
            }
        }
    }
}

struct StatView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            HikeDetailCard(
                hike: Hike.sampleHikes[0],
                isPresented: .constant(true),
                onDismiss: {}
            )
        }
    }
}