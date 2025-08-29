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
    @State private var sheetDetent: PresentationDetent = .height(DesignSystem.Sheet.collapsedHeight)
    @State private var sheetHeight: CGFloat = 0
    @State private var animationDuration: CGFloat = 0
    @State private var toolbarOpacity: CGFloat = 1
    @State private var safeAreaBottomInset: CGFloat = 0
    @State private var isTrackingUserLocation: Bool = false
    @State private var programmaticPositionChange: Bool = false
    @State private var isSearchFocused: Bool = false
    
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
                        HikeSelectionAnimator.animateHikeSelection(
                            hike: hike,
                            currentSheetDetent: $sheetDetent,
                            selectedHike: $selectedHike,
                            sheetContent: $sheetContent,
                            position: $position,
                            isTrackingUserLocation: $isTrackingUserLocation,
                            programmaticPositionChange: $programmaticPositionChange
                        )
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
        .mapStyle(.standard(elevation: .realistic, emphasis: .automatic, pointsOfInterest: .excluding([.store, .restaurant, .gasStation, .hotel, .nightlife, .airport, .amusementPark, .aquarium, .atm, .bakery, .bank, .brewery, .cafe, .carRental, .evCharger, .fitnessCenter, .foodMarket, .laundry, .library, .marina, .movieTheater, .museum, .pharmacy, .postOffice, .school, .stadium, .store, .theater, .university, .winery, .zoo]), showsTraffic: false))
        .ignoresSafeArea(.container, edges: .top)
        .overlay(alignment: .top) {
            // Status bar blur for better readability
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(height: DesignSystem.Map.statusBarBlurHeight)
            }
            .mask(
                LinearGradient(
                    colors: [
                        Color.white,
                        Color.white.opacity(0.8),
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(.container, edges: .top)
        }
    }
    
    var body: some View {
        mapView
            .sheet(isPresented: $showBottomSheet) {
                ZStack {
                    // Base layer - always present search/list view
                    HikeBottomSheetView(
                        sheetDetent: $sheetDetent,
                        searchText: $searchText,
                        isSearchFocused: $isSearchFocused,
                        hikes: hikes,
                        onHikeSelected: { hike in
                            HikeSelectionAnimator.animateHikeSelection(
                                hike: hike,
                                currentSheetDetent: $sheetDetent,
                                selectedHike: $selectedHike,
                                sheetContent: $sheetContent,
                                position: $position,
                                isTrackingUserLocation: $isTrackingUserLocation,
                                programmaticPositionChange: $programmaticPositionChange
                            )
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
                        .opacity(isSearchFocused ? 0 : 1)
                        .animation(.interpolatingSpring(duration: 0.4, bounce: 0.1), value: sheetContent)
                        .animation(.easeInOut(duration: 0.2), value: isSearchFocused)
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
                    
                    // Start fading when sheet goes above intermediate position (350)
                    let fadeStartHeight = 350 + safeAreaBottomInset
                    let fadeRange: CGFloat = 100 // Fade over 100 points of movement
                    let progress = max(min((newValue - fadeStartHeight) / fadeRange, 1), 0)
                    toolbarOpacity = 1 - progress
                    
                    let diff = abs(newValue - oldValue)
                    let duration = max(min(diff / 100, maxAnimationDuration), 0)
                    animationDuration = duration
                }
                .ignoresSafeArea()
                .interactiveDismissDisabled()
            }
            .overlay(alignment: .bottomTrailing) {
                MapFloatingToolbar(
                    locationManager: locationManager,
                    isTrackingUserLocation: isTrackingUserLocation,
                    toolbarOpacity: toolbarOpacity,
                    sheetHeight: sheetHeight,
                    safeAreaBottomInset: safeAreaBottomInset,
                    animation: animation,
                    onLocationButtonTapped: handleLocationButtonTap
                )
            }
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
        .onChange(of: position) { oldValue, newValue in
            // If position changed and it wasn't a programmatic change, user dragged the map
            if isTrackingUserLocation && !programmaticPositionChange {
                isTrackingUserLocation = false
            }
            // Reset the flag after checking
            if programmaticPositionChange {
                DispatchQueue.main.async {
                    programmaticPositionChange = false
                }
            }
        }
        .onChange(of: sheetDetent) { oldValue, newValue in
            // Immediately hide toolbar when sheet is fully expanded
            withAnimation(.easeInOut(duration: 0.2)) {
                if newValue == .large {
                    toolbarOpacity = 0
                } else if newValue == .height(350) {
                    toolbarOpacity = 1
                }
            }
        }
        .onChange(of: isSearchFocused) { oldValue, newValue in
            // Immediately hide toolbar when search is focused
            withAnimation(.easeInOut(duration: 0.2)) {
                toolbarOpacity = newValue ? 0 : 1
            }
        }
    }
    
    
    var maxAnimationDuration: CGFloat {
        return DesignSystem.Animation.maxDuration
    }
    
    var animation: Animation {
        .interpolatingSpring(duration: animationDuration, bounce: 0, initialVelocity: 0)
    }
    
    
    // MARK: - Location Button Handler
    private func handleLocationButtonTap() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if isTrackingUserLocation {
            // If already tracking, turn off tracking by going to automatic position
            withAnimation(.easeInOut(duration: DesignSystem.Animation.slow)) {
                position = .automatic
                isTrackingUserLocation = false
            }
        } else {
            // If not tracking, start tracking user location
            programmaticPositionChange = true
            withAnimation(.easeInOut(duration: DesignSystem.Animation.slow)) {
                position = .userLocation(followsHeading: false, fallback: .automatic)
                isTrackingUserLocation = true
            }
        }
    }
    
    var availableDetents: Set<PresentationDetent> {
        return [
            .height(DesignSystem.Sheet.collapsedHeight), 
            .height(DesignSystem.Sheet.expandedHeight), 
            .large
        ]
    }
}

#Preview {
    HikeMapView()
}