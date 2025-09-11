//
//  SearchBarView.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI

struct SearchBarView: View {
  @Binding var searchText: String
  @Binding var showingSearch: Bool
  @FocusState private var searchFieldFocused: Bool

  var body: some View {
    HStack(spacing: 12) {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(.secondary)

        TextField("Search for hikes or locations", text: $searchText)
          .focused($searchFieldFocused)
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
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .background(.regularMaterial)
      .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
      .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
  }
}

#Preview {
  VStack {
    SearchBarView(searchText: .constant(""), showingSearch: .constant(false))
      .padding()

    SearchBarView(searchText: .constant("Eagle Peak"), showingSearch: .constant(true))
      .padding()
  }
  .background(Color.gray.opacity(0.2))
}
