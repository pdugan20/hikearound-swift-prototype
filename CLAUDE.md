# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI-based iOS hiking app prototype called "Hikearound". The app features a full-screen MapKit integration with glass-morphic UI design, built for iOS 18+ using Xcode 16 beta.

## Build and Run Commands

### Building the Project
```bash
# Build for iOS Simulator
xcodebuild -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=iOS Simulator,name=iPhone 16' build

# Build for macOS
xcodebuild -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=macOS' build
```

### Running Tests
```bash
# Run unit tests
xcodebuild test -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests
xcodebuild test -project hikearound-prototype.xcodeproj -scheme hikearound-prototypeUITests -destination 'platform=iOS Simulator,name=iPhone 16'

# Run a specific test
xcodebuild test -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:hikearound_prototypeTests/hikearound_prototypeTests/testExample
```

### Code Quality
```bash
# Format Swift code (requires swift-format installation)
swift-format -i -r hikearound-prototype/

# Lint Swift code (requires SwiftLint installation)
swiftlint lint --path hikearound-prototype/
```

## Project Architecture

### Directory Structure
```
hikearound-prototype/
├── App/
│   └── Hikearound.swift           # @main app entry point
├── Core/
│   ├── Models/
│   │   └── Hike.swift            # Core data models with sample data & formatting
│   ├── Services/
│   │   └── LocationManager.swift # CLLocationManager wrapper, ObservableObject
│   ├── Views/
│   │   └── MainView.swift        # Root view container
│   ├── Constants/
│   │   └── DesignSystem.swift    # Centralized design constants and spacing
│   └── Utilities/
│       └── HikeSelectionAnimator.swift # Animation coordination helper
├── Features/
│   ├── Map/
│   │   ├── Views/
│   │   │   └── HikeMapView.swift # Main map implementation with MapKit
│   │   └── Components/
│   │       ├── HikeMarkerView.swift  # Custom annotation views
│   │       ├── HikeDetailSheet.swift # Detail overlay component
│   │       ├── HikeBottomSheetView.swift # Search and list view
│   │       ├── MapFloatingToolbar.swift # Location/direction buttons
│   │       └── StatView.swift       # Reusable stat display component
│   └── Search/
│       └── SearchBarView.swift   # Glass-morphic search bar
```

### Key Technical Details

- **MapKit Integration**: Uses `Map` with `MapCameraPosition`, custom `Annotation` views, and `MapControls`
- **Glass UI**: Implements `.regularMaterial` and `.ultraThinMaterial` throughout
- **Location Services**: Custom `LocationManager` class conforming to `ObservableObject` and `CLLocationManagerDelegate`
- **State Management**: Uses `@State`, `@StateObject`, `@Published` for reactive UI
- **Animations**: Spring animations with `.bouncy` timing curves

### Testing Architecture
- **Unit Tests**: Uses Swift Testing framework (`import Testing`) with modern `@Test` attributes
- **UI Tests**: Uses XCTest framework for UI automation testing

### Important Patterns
- All views use SwiftUI's declarative syntax
- Location permissions configured via Info.plist keys in project settings
- Preview providers included for all components
- Dark mode optimized with glass effects