//
//  HikeSelectionAnimator.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI
import MapKit

struct HikeSelectionAnimator {
    
    static func animateHikeSelection(
        hike: Hike,
        currentSheetDetent: Binding<PresentationDetent>,
        selectedHike: Binding<Hike?>,
        sheetContent: Binding<HikeMapView.SheetContent>,
        position: Binding<MapCameraPosition>,
        isTrackingUserLocation: Binding<Bool>,
        programmaticPositionChange: Binding<Bool>
    ) {
        selectedHike.wrappedValue = hike
        
        // If sheet is collapsed, expand it first, then show hike detail
        if currentSheetDetent.wrappedValue == .height(DesignSystem.Sheet.collapsedHeight) {
            withAnimation(.interpolatingSpring(duration: DesignSystem.Animation.standard, bounce: 0.1)) {
                currentSheetDetent.wrappedValue = .height(DesignSystem.Sheet.expandedHeight)
            }
            // Delay hike detail animation until sheet expansion completes
            DispatchQueue.main.asyncAfter(deadline: .now() + DesignSystem.Animation.quick) {
                withAnimation(.interpolatingSpring(duration: DesignSystem.Animation.medium, bounce: 0.1)) {
                    sheetContent.wrappedValue = .hikeDetail(hike)
                }
            }
        } else {
            // Sheet is already expanded, show hike detail immediately
            withAnimation(.interpolatingSpring(duration: DesignSystem.Animation.medium, bounce: 0.1)) {
                sheetContent.wrappedValue = .hikeDetail(hike)
            }
        }
        
        // Move map to hike location
        programmaticPositionChange.wrappedValue = true
        withAnimation(.bouncy) {
            position.wrappedValue = .camera(
                MapCamera(
                    centerCoordinate: hike.coordinate,
                    distance: DesignSystem.Map.cameraDistance,
                    pitch: DesignSystem.Map.cameraPitch
                )
            )
            isTrackingUserLocation.wrappedValue = false
        }
    }
}