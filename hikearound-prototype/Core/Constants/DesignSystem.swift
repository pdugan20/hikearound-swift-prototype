//
//  DesignSystem.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct DesignSystem {

  // MARK: - Sheet Configuration
  struct Sheet {
    static let collapsedHeight: CGFloat = 80
    static let expandedHeight: CGFloat = 350
    static let hikeDetailHeight: CGFloat = 400
    static let cornerRadius: CGFloat = 30
  }

  // MARK: - Animation Durations
  struct Animation {
    static let quick: Double = 0.2
    static let standard: Double = 0.3
    static let medium: Double = 0.4
    static let slow: Double = 0.5
    static let maxDuration: CGFloat = 0.25
    static let springResponse: Double = 0.6
    static let springDamping: Double = 0.8
  }

  // MARK: - Map Configuration
  struct Map {
    static let cameraDistance: Double = 5000
    static let cameraPitch: Double = 0
    static let statusBarBlurHeight: CGFloat = 100
  }

  // MARK: - Spacing & Layout
  struct Spacing {
    static let small: CGFloat = 10
    static let medium: CGFloat = 15
    static let large: CGFloat = 20
    static let extraLarge: CGFloat = 32
    static let toolbarSpacing: CGFloat = 35
  }

  // MARK: - Component Sizes
  struct Size {
    struct Marker {
      static let container: CGFloat = 44
      static let circle: CGFloat = 36
      static let innerCircle: CGFloat = 20
      static let dot: CGFloat = 16
    }

    struct Button {
      static let large: CGFloat = 48
      static let medium: CGFloat = 36
    }
  }

  // MARK: - Effects & Opacity
  struct Effects {
    static let opacityCalculationDivisor: CGFloat = 50
    static let animationDivisor: CGFloat = 100
    static let markerScaleActive: CGFloat = 1.2
  }
}
