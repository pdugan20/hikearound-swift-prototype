//
//  StatView.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

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
  HStack(spacing: 20) {
    StatView(icon: "arrow.up.forward", title: "Elevation", value: "1,200 ft")
    StatView(icon: "clock", title: "Duration", value: "2h 30m")
    StatView(icon: "location", title: "Distance", value: "5.2 mi")
  }
  .padding()
  .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
}
