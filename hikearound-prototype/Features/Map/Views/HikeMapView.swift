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
    @StateObject private var locationManager = LocationManager()
    @Namespace private var mapScope
    
    let hikes = Hike.sampleHikes
    
    @MapContentBuilder
    private var mapContent: some MapContent {
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
    
    private var mapView: some View {
        Map(position: $position, selection: $mapSelection, scope: mapScope) {
            mapContent
        }
        .mapStyle(.standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .excludingAll, showsTraffic: false))
        .ignoresSafeArea(.container, edges: .top)
    }
    
    var body: some View {
        ZStack {
            mapView
            
            // Search bar overlay
            VStack {
                SearchBarView(searchText: $searchText, showingSearch: $showingSearch)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
            }
            
            
            // Custom positioned map controls at bottom
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Spacer()
                    
                    MapUserLocationButton(scope: mapScope)
                        .mapControlVisibility(.visible)
                        .clipShape(Circle())
                        .background(Circle().fill(.regularMaterial))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, selectedHike == nil ? 20 : 280)
                .padding(.trailing, 16)
            }
            
            // Hike detail card overlay
            if let selectedHike {
                VStack {
                    Spacer()
                    HikeDetailCard(hike: selectedHike, isPresented: .constant(true)) {
                        withAnimation {
                            self.selectedHike = nil
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .mapScope(mapScope)
        .onAppear {
            // Request location permission when view appears
            locationManager.requestWhenInUseAuthorization()
        }
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