//
//  MapFloatingToolbar.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI
import MapKit

struct MapFloatingToolbar: View {
    let locationManager: LocationManager
    let isTrackingUserLocation: Bool
    let toolbarOpacity: CGFloat
    let sheetHeight: CGFloat
    let safeAreaBottomInset: CGFloat
    let animation: Animation
    let onLocationButtonTapped: () -> Void
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.toolbarSpacing) {
            Button {
                // Car/Directions action
            } label: {
                Image(systemName: "car.fill")
            }
            
            Button {
                onLocationButtonTapped()
            } label: {
                Image(systemName: locationButtonIcon)
                    .foregroundStyle(locationButtonColor)
            }
        }
        .font(.title3)
        .foregroundStyle(Color.primary)
        .padding(.vertical, DesignSystem.Spacing.large)
        .padding(.horizontal, DesignSystem.Spacing.small)
        .glassEffect(.regular, in: .capsule)
        .opacity(toolbarOpacity)
        .offset(y: {
            // Reduce spacing as sheet expands
            let baseSpacing = DesignSystem.Spacing.small
            let reducedSpacing = sheetHeight > 200 ? baseSpacing * 0.3 : baseSpacing
            return -sheetHeight - reducedSpacing
        }())
        .animation(animation, value: sheetHeight)
        .animation(animation, value: toolbarOpacity)
        .padding(.trailing, DesignSystem.Spacing.medium)
        .offset(y: safeAreaBottomInset - DesignSystem.Spacing.small)
    }
    
    private var locationButtonIcon: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "location"
        case .denied, .restricted:
            return "location.slash"
        case .authorizedWhenInUse, .authorizedAlways:
            if isTrackingUserLocation {
                return "location.fill"
            } else {
                return "location"
            }
        @unknown default:
            return "location"
        }
    }
    
    private var locationButtonColor: Color {
        switch locationManager.authorizationStatus {
        case .denied, .restricted:
            return .red
        case .authorizedWhenInUse, .authorizedAlways:
            return .blue
        default:
            return .blue
        }
    }
}

#Preview {
    MapFloatingToolbar(
        locationManager: LocationManager(),
        isTrackingUserLocation: false,
        toolbarOpacity: 1.0,
        sheetHeight: 0,
        safeAreaBottomInset: 0,
        animation: .bouncy,
        onLocationButtonTapped: {}
    )
    .padding()
    .background(Color(.systemGray6))
}