//
//  HikeBottomSheetView.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct HikeBottomSheetView: View {
  @Binding var sheetDetent: PresentationDetent
  @Binding var searchText: String
  @Binding var isSearchFocused: Bool
  @FocusState private var isFocused: Bool

  let hikes: [Hike]
  let onHikeSelected: (Hike) -> Void

  var body: some View {
    ScrollView(.vertical) {
      // Hike list view
      LazyVStack(spacing: 12) {
        ForEach(filteredHikes) { hike in
          HikeRowView(hike: hike) {
            onHikeSelected(hike)
          }
        }
      }
      .padding(.horizontal)
      .padding(.top)
    }
    .safeAreaInset(edge: .top, spacing: 0) {
      HStack(spacing: 10) {
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundStyle(.secondary)

          TextField("Search for hikes or locations", text: $searchText)
            .focused($isFocused)
            .textFieldStyle(.plain)

          if !searchText.isEmpty {
            Button {
              searchText = ""
            } label: {
              Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
            }
          }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.gray.opacity(0.25), in: .capsule)

        // Profile/Close Button
        Button {
          if isFocused {
            isFocused = false
          } else {
            // Profile action
          }
        } label: {
          ZStack {
            Image("ProfilePhoto")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 44, height: 44)
              .clipShape(Circle())
              .overlay(
                Circle()
                  .stroke(Color.white.opacity(0.2), lineWidth: 1)
              )

            if isFocused {
              // Cover the profile photo with background color
              Rectangle()
                .fill(Color(UIColor.systemBackground))
                .frame(width: 50, height: 50)
                .allowsHitTesting(false)

              // Show the X button with glass effect
              Image(systemName: "xmark")
                .frame(width: 44, height: 44)
                .glassEffect(in: .circle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .allowsHitTesting(false)
            }
          }
        }
        .buttonStyle(.plain)
      }
      .padding(.horizontal, 18)
      .padding(.vertical, 18)
    }
    .animation(.interpolatingSpring(duration: 0.3, bounce: 0, initialVelocity: 0), value: isFocused)
    .onChange(of: isFocused) { _, newValue in
      sheetDetent = newValue ? .large : .height(350)
      isSearchFocused = newValue
    }
    .onAppear {
      isFocused = isSearchFocused
    }
  }

  private var filteredHikes: [Hike] {
    if searchText.isEmpty {
      return hikes
    } else {
      return hikes.filter { hike in
        hike.name.localizedCaseInsensitiveContains(searchText)
          || hike.description.localizedCaseInsensitiveContains(searchText)
          || hike.difficulty.rawValue.localizedCaseInsensitiveContains(searchText)
      }
    }
  }
}

struct HikeRowView: View {
  let hike: Hike
  let onTap: () -> Void

  var body: some View {
    Button {
      onTap()
    } label: {
      HStack(spacing: 12) {
        // Difficulty indicator
        Circle()
          .fill(hike.difficulty.color)
          .frame(width: 12, height: 12)

        VStack(alignment: .leading, spacing: 4) {
          Text(hike.name)
            .font(.headline)
            .foregroundStyle(.primary)

          HStack(spacing: 8) {
            Text(hike.difficulty.rawValue)
              .font(.caption)
              .foregroundStyle(hike.difficulty.color)

            Text("•")
              .font(.caption)
              .foregroundStyle(.secondary)

            Text(hike.formattedDistance)
              .font(.caption)
              .foregroundStyle(.secondary)

            Text("•")
              .font(.caption)
              .foregroundStyle(.secondary)

            Text(hike.formattedElevation)
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }

        Spacer()

        Image(systemName: "chevron.right")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .padding(.vertical, 8)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  HikeBottomSheetView(
    sheetDetent: .constant(.height(350)),
    searchText: .constant(""),
    isSearchFocused: .constant(false),
    hikes: Hike.sampleHikes,
    onHikeSelected: { _ in }
  )
}
