# Hikearound

A modern iOS hiking app prototype built with SwiftUI and MapKit, featuring a beautiful glass-morphic UI design inspired by iOS 18's latest design language.

## Features

- 🗺️ **Full-screen MapKit Integration** - Immersive map experience with realistic terrain elevation
- 🥾 **Interactive Hike Markers** - Custom animated markers showing hiking trail locations
- 🔍 **Search Functionality** - Find hikes and locations with a floating search bar
- 📍 **Location Services** - Real-time user location tracking on the map
- 🎨 **Glass-morphic UI** - Modern translucent design with blur effects throughout
- 📱 **Native iOS Experience** - Built entirely with SwiftUI for smooth, native performance

## Screenshots

The app features:
- Full-screen Apple Maps with hiking trail markers
- Tap-to-reveal detail cards with hike information
- Floating search bar with glass effect
- Trail difficulty indicators and statistics

## Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **MapKit** - Native Apple Maps integration
- **CoreLocation** - Location services and tracking
- **Swift 5.0** - Latest Swift language features
- **iOS 18+** - Targeting latest iOS features

## Project Structure

```
hikearound-prototype/
├── App/
│   └── Hikearound.swift           # Main app entry point
├── Core/
│   ├── Models/
│   │   └── Hike.swift            # Hike data model
│   ├── Services/
│   │   └── LocationManager.swift # Location services manager
│   └── Views/
│       └── MainView.swift        # Main app view
├── Features/
│   ├── Map/
│   │   ├── Views/
│   │   │   └── HikeMapView.swift # Main map view
│   │   └── Components/
│   │       ├── HikeMarkerView.swift  # Custom map markers
│   │       └── HikeDetailCard.swift  # Hike detail overlay
│   └── Search/
│       └── SearchBarView.swift   # Search interface
└── Assets.xcassets/              # App assets and icons
```

## Getting Started

### Prerequisites

- Xcode 16.0 or later (Beta)
- iOS 18.0+ deployment target
- macOS 14.0 or later

### Installation

1. Clone the repository:
```bash
git clone https://github.com/[username]/hikearound-prototype.git
```

2. Open in Xcode:
```bash
cd hikearound-prototype
open hikearound-prototype.xcodeproj
```

3. Build and run:
- Select your target device or simulator
- Press `Cmd + R` to build and run

## Development

### Building

```bash
# Build for iOS Simulator
xcodebuild -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=iOS Simulator,name=iPhone 16' build

# Build for macOS
xcodebuild -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=macOS' build
```

### Testing

```bash
# Run unit tests
xcodebuild test -project hikearound-prototype.xcodeproj -scheme hikearound-prototype -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Features in Detail

### Map Integration
- Full-screen MapKit view with 3D terrain
- Custom hiking trail annotations
- User location tracking
- Map controls (compass, pitch toggle, location button)

### Hike Information
- Trail difficulty levels (Easy, Moderate, Hard, Expert)
- Distance and elevation gain statistics
- Estimated hiking time
- Detailed trail descriptions

### UI/UX Design
- Glass-morphic design language throughout
- Smooth spring animations
- Gesture-driven interactions
- Dark mode optimized

## Sample Data

The app includes 5 sample hikes around the San Francisco Bay Area:
- Eagle Peak Trail (Moderate, 5.2 mi)
- Redwood Loop (Easy, 2.8 mi)
- Summit Ridge Trail (Expert, 12.5 mi)
- Coastal Bluff Walk (Easy, 3.5 mi)
- Mountain Lake Trail (Hard, 8.3 mi)

## Future Enhancements

- [ ] Real hiking trail API integration
- [ ] Offline map downloads
- [ ] Trail recording and tracking
- [ ] Social features and trail reviews
- [ ] Weather integration
- [ ] Apple Watch companion app
- [ ] Trail photos and galleries
- [ ] Elevation profile charts

## Contributing

This is a prototype project for demonstration purposes. Feel free to fork and expand upon it!

## License

MIT License - feel free to use this code for your own projects.

## Author

Created by Patrick Dugan on 8/28/25

---

Built with SwiftUI and ❤️ for the hiking community