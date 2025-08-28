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
    
    // Bottom Sheet Properties
    @State private var showBottomSheet: Bool = true
    @State private var sheetDetent: PresentationDetent = .height(80)
    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1
    @State private var safeAreaBottomInset: CGFloat = 0
    
    // Sheet Content State
    enum SheetContent: Equatable {
        case searchList
        case hikeDetail(Hike)
    }
    @State private var sheetContent: SheetContent = .searchList
    
    let hikes = Hike.sampleHikes
    
    @MapContentBuilder
    private var mapContent: some MapContent {
        ForEach(hikes) { hike in
            Annotation(hike.name, coordinate: hike.coordinate, anchor: .bottom) {
                HikeMarkerView(hike: hike, isSelected: selectedHike?.id == hike.id)
                    .onTapGesture {
                        selectedHike = hike
                        
                        // If sheet is collapsed, expand it first, then show hike detail
                        if sheetDetent == .height(80) {
                            withAnimation(.interpolatingSpring(duration: 0.3, bounce: 0.1)) {
                                sheetDetent = .height(350)
                            }
                            // Delay hike detail animation until sheet expansion completes
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.interpolatingSpring(duration: 0.4, bounce: 0.1)) {
                                    sheetContent = .hikeDetail(hike)
                                }
                            }
                        } else {
                            // Sheet is already expanded, show hike detail immediately
                            withAnimation(.interpolatingSpring(duration: 0.4, bounce: 0.1)) {
                                sheetContent = .hikeDetail(hike)
                            }
                        }
                        
                        withAnimation(.bouncy) {
                            position = .camera(
                                MapCamera(
                                    centerCoordinate: hike.coordinate,
                                    distance: 5000,
                                    pitch: 0
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
        mapView
            .sheet(isPresented: $showBottomSheet) {
                ZStack {
                    // Base layer - always present search/list view
                    HikeBottomSheetView(
                        sheetDetent: $sheetDetent,
                        searchText: $searchText,
                        hikes: hikes,
                        onHikeSelected: { hike in
                            selectedHike = hike
                            
                            // If sheet is collapsed, expand it first, then show hike detail
                            if sheetDetent == .height(80) {
                                withAnimation(.interpolatingSpring(duration: 0.3, bounce: 0.1)) {
                                    sheetDetent = .height(350)
                                }
                                // Delay hike detail animation until sheet expansion completes
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.interpolatingSpring(duration: 0.4, bounce: 0.1)) {
                                        sheetContent = .hikeDetail(hike)
                                    }
                                }
                            } else {
                                // Sheet is already expanded, show hike detail immediately
                                withAnimation(.interpolatingSpring(duration: 0.4, bounce: 0.1)) {
                                    sheetContent = .hikeDetail(hike)
                                }
                            }
                            
                            withAnimation(.bouncy) {
                                position = .camera(
                                    MapCamera(
                                        centerCoordinate: hike.coordinate,
                                        distance: 5000,
                                        pitch: 0
                                    )
                                )
                            }
                        }
                    )
                    
                    // Hike detail sheet - always rendered, positioned based on state
                    GeometryReader { geometry in
                        HikeDetailSheet(hike: selectedHike ?? hikes[0]) {
                            withAnimation(.interpolatingSpring(duration: 0.4, bounce: 0.1)) {
                                sheetContent = .searchList
                                self.selectedHike = nil
                            }
                        }
                        .offset(
                            y: {
                                if case .hikeDetail = sheetContent {
                                    return 0
                                } else {
                                    return geometry.size.height + 100
                                }
                            }()
                        )
                        .animation(.interpolatingSpring(duration: 0.4, bounce: 0.1), value: sheetContent)
                    }
                    .zIndex(1)
                }
                .presentationDetents(availableDetents, selection: $sheetDetent)
                .presentationBackgroundInteraction(.enabled)
                .presentationCornerRadius(nil)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onGeometryChange(for: CGFloat.self) {
                    max(min($0.size.height, 400 + safeAreaBottomInset), 0)
                } action: { oldValue, newValue in
                    sheetHeight = min(newValue, 400 + safeAreaBottomInset)
                    
                    let progress = max(min((newValue - (400 + safeAreaBottomInset)) / 50, 1), 0)
                    toolbarOpacity = 1 - progress
                    
                    let diff = abs(newValue - oldValue)
                    let duration = max(min(diff / 100, maxAnimationDuration), 0)
                    animationDuration = duration
                }
                .ignoresSafeArea()
                .interactiveDismissDisabled()
            }
            .overlay(alignment: .bottomTrailing) {
                floatingToolbar
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
        .onGeometryChange(for: CGFloat.self, of: {
            $0.safeAreaInsets.bottom
        }, action: { newValue in
            safeAreaBottomInset = newValue
        })
    }
    
    @ViewBuilder
    var floatingToolbar: some View {
        Group {
            VStack(spacing: 35) {
                Button {
                    // Car/Directions action
                } label: {
                    Image(systemName: "car.fill")
                }
                
                Button {
                    if locationManager.authorizationStatus == .notDetermined {
                        locationManager.requestWhenInUseAuthorization()
                    }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        position = .userLocation(fallback: .automatic)
                    }
                } label: {
                    Image(systemName: "location")
                }
            }
            .font(.title3)
            .foregroundStyle(Color.primary)
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .glassEffect(.regular, in: .capsule)
            .opacity(toolbarOpacity)
            .offset(y: -sheetHeight)
        }
        .animation(animation, value: sheetHeight)
        .animation(animation, value: toolbarOpacity)
        .padding(.trailing, 15)
        .offset(y: safeAreaBottomInset - 10)
    }
    
    var maxAnimationDuration: CGFloat {
        return 0.25
    }
    
    var animation: Animation {
        .interpolatingSpring(duration: animationDuration, bounce: 0, initialVelocity: 0)
    }
    
    
    var availableDetents: Set<PresentationDetent> {
        return [.height(80), .height(350), .large]
    }
}

#Preview {
    HikeMapView()
}