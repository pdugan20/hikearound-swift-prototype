//
//  HikeMapView.swift
//  hikearound-prototype
//
//  Created by Patrick Dugan on 8/28/25.
//

import SwiftUI
import MapKit

struct HikeMapView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedHike: Hike?
    @State private var searchText = ""
    @State private var showingSearch = false
    @State private var mapSelection: String?
    @State private var lookAroundScene: MKLookAroundScene?
    @Namespace private var mapNamespace
    
    let hikes = Hike.sampleHikes
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $mapSelection) {
                ForEach(hikes) { hike in
                    Annotation(hike.name, coordinate: hike.coordinate, anchor: .bottom) {
                        HikeMarkerView(hike: hike, isSelected: selectedHike?.id == hike.id)
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    selectedHike = hike
                                    position = .camera(
                                        MapCamera(
                                            centerCoordinate: hike.coordinate,
                                            distance: 5000,
                                            pitch: 45
                                        )
                                    )
                                }
                            }
                    }
                    .tag(hike.id.uuidString)
                }
                
                UserAnnotation()
            }
            .mapStyle(.standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
            }
            .safeAreaInset(edge: .bottom) {
                if let selectedHike {
                    HikeDetailCard(hike: selectedHike, isPresented: .constant(true)) {
                        withAnimation {
                            self.selectedHike = nil
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .safeAreaInset(edge: .top) {
                SearchBarView(searchText: $searchText, showingSearch: $showingSearch)
                    .padding(.horizontal)
                    .padding(.top, 8)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onChange(of: mapSelection) { oldValue, newValue in
            if let hikeId = newValue,
               let hike = hikes.first(where: { $0.id.uuidString == hikeId }) {
                selectedHike = hike
            }
        }
    }
}

#Preview {
    HikeMapView()
}