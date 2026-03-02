# MyPerro - Pet Tracking & Safety App

A comprehensive pet tracking and safety application built with Flutter. Track your pet's location, set up geofences, and receive alerts when your pet wanders outside safe zones.

## 📱 Features

### ✅ Implemented

- ✅ **Pet Registration** - Complete onboarding flow with pet details, photos, and health records
- ✅ **GPS Tracking** - Real-time location tracking using OpenStreetMap
- ✅ **User Authentication** - Email, Google, and Apple sign-in (UI ready)
- ✅ **Dashboard** - Pet activity tracking, walk statistics, and safety metrics
- ✅ **Profile Management** - User profiles, subscriptions, and settings
- ✅ **Multi-User Access** - Share pet access with caretakers and family members

### 🚧 In Development (See [ROADMAP.md](ROADMAP.md))

- 🚧 **BLE Collar Communication** - Bluetooth connectivity with pet collar devices
- 🚧 **QR Code Pairing** - Scan collar IMEI for quick setup
- 🚧 **Geofence Setup** - Set custom safe zones for your pet
- 🚧 **GPS Verification** - Verify collar GPS accuracy during setup
- 🚧 **Lost Mode** - Automatic alerts and tracking when pet leaves safe zone
- 🚧 **Backend Integration** - API for registration, tracking, and alerts

### 📋 Planned

- 📋 **Push Notifications** - Real-time alerts for lost mode
- 📋 **Location History** - Historical tracking data and analytics
- 📋 **Emergency Contacts** - Share pet location with trusted contacts

## 🗂️ Project Documentation

- **[ROADMAP.md](ROADMAP.md)** - Detailed implementation roadmap with 8 phases
- **[TODO.md](TODO.md)** - Current sprint tasks and immediate action items
- **SRS Document** - See top of ROADMAP.md for requirements

## 🏗️ Project Structure

```
lib/
├── core/                      # Core business logic
│   ├── auth/                 # Authentication services
│   ├── location/             # GPS & location services ✅
│   ├── router/               # Navigation & routing ✅
│   ├── ble/                  # BLE communication (Phase 3) 🚧
│   ├── api/                  # Backend API client (Phase 2) 🚧
│   ├── models/               # Data models (Phase 1) 🚧
│   └── storage/              # Local storage (Phase 1) 🚧
│
├── features/                  # Feature modules
│   └── collar_setup/         # Collar pairing wizard (Phase 4-5) 🚧
│
├── ui/                       # User interface
│   ├── screens/              # All app screens ✅
│   ├── widgets/              # Reusable widgets ✅
│   └── theme/                # App theming ✅
│
└── utils/                    # Utility functions
    └── distance_calculator.dart  # GPS distance calc (Phase 5) 🚧
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >= 3.3.1
- Android Studio / Xcode
- Android device/emulator (API 21+)
- iOS device/simulator (iOS 12.0+)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd myperro_app-main
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # Android
   flutter run

   # iOS
   flutter run
   ```

### Development Setup (Phase 0)

For collar setup development, install additional packages:

```bash
flutter pub add flutter_blue_plus mobile_scanner flutter_riverpod shared_preferences freezed_annotation json_annotation permission_handler

flutter pub add --dev build_runner freezed json_serializable
```

See [TODO.md](TODO.md) for detailed Phase 0 setup instructions.

## 📦 Dependencies

### Core Packages

- `google_fonts` - Typography
- `flutter_svg` - SVG support
- `rive` - Animations
- `font_awesome_flutter` - Icons

### Location & Maps (OpenStreetMap - FREE)

- `flutter_map` - Map rendering ✅
- `latlong2` - Coordinate handling ✅
- `geolocator` - GPS location services ✅
- `geocoding` - Reverse geocoding ✅

### Networking & Media

- `http` - API requests
- `image_picker` - Photo selection
- `file_picker` - Document selection

### In Development (Phase 0-3)

- `flutter_blue_plus` - BLE communication 🚧
- `mobile_scanner` - QR code scanning 🚧
- `flutter_riverpod` - State management 🚧
- `shared_preferences` - Local storage 🚧
- `freezed` - Data models 🚧

## 🛠️ Current Development Status

**Overall Progress:** 10% (2/19 SRS requirements complete)

**Current Phase:** Phase 0 - Foundation & Setup

**Next Milestone:** Complete Phase 0 (Package installation & configuration)

See [ROADMAP.md](ROADMAP.md) for detailed progress and phase breakdown.

## 📊 Development Phases

| Phase | Name | Status | Duration |
|-------|------|--------|----------|
| Phase 0 | Foundation & Setup | 🔴 Not Started | Week 1 |
| Phase 1 | Data Models & Storage | 🔴 Not Started | Week 1-2 |
| Phase 2 | Backend API Integration | 🔴 Not Started | Week 2 |
| Phase 3 | BLE Service Layer | 🔴 Not Started | Week 3-4 |
| Phase 4 | QR & Pairing Screens | 🔴 Not Started | Week 4-5 |
| Phase 5 | Geofence & GPS Test | 🔴 Not Started | Week 5-6 |
| Phase 6 | Integration | 🔴 Not Started | Week 6-7 |
| Phase 7 | Testing & Refinement | 🔴 Not Started | Week 7-8 |
| Phase 8 | Lost Mode (Future) | 🔴 Not Started | Week 8+ |

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ⬜ Web (Not planned)

## 🔐 Permissions Required

### Android (AndroidManifest.xml)

- `INTERNET` - API communication & map tiles ✅
- `ACCESS_FINE_LOCATION` - GPS tracking ✅
- `ACCESS_COARSE_LOCATION` - GPS tracking ✅
- `BLUETOOTH` - Collar communication 🚧
- `BLUETOOTH_SCAN` - Device discovery 🚧
- `BLUETOOTH_CONNECT` - Device pairing 🚧
- `CAMERA` - QR code scanning 🚧

### iOS (Info.plist)

- `NSLocationWhenInUseUsageDescription` ✅
- `NSBluetoothAlwaysUsageDescription` 🚧
- `NSCameraUsageDescription` 🚧

## 🤝 Contributing

1. Review [ROADMAP.md](ROADMAP.md) for current development phase
2. Check [TODO.md](TODO.md) for available tasks
3. Create a feature branch
4. Submit a pull request

## 📝 License

[Your License Here]

## 📞 Contact

For questions or support:

- **Developer:** [Your Name]
- **Project Repository:** [Repository URL]
- **Documentation:** See [ROADMAP.md](ROADMAP.md)

## 🎯 Quick Start for New Developers

1. Read [ROADMAP.md](ROADMAP.md) to understand the project scope
2. Review [TODO.md](TODO.md) for current tasks
3. Set up your development environment (see Getting Started)
4. Pick a task from TODO.md
5. Join the team communication channel

---

**Last Updated:** 2025-12-28
**Current Sprint:** Phase 0 - Foundation & Setup
**Next Review:** [Schedule team review]
