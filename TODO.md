# FindMyPerro - TODO Tracker

> **Last Updated:** 2025-12-28
> **Phases 0-3: COMPLETE ✅** | **Next: Phase 4 - Collar Setup Wizard**

---

## 🔥 Immediate Next Steps

### ✅ Completed Phases

- [x] ~~**Phase 0: Foundation Setup**~~ ✅ **COMPLETE**
  - ✅ Installed all required packages (64 new packages)
  - ✅ Configured Android & iOS permissions
  - ✅ Created folder structure
  - ✅ Set up Riverpod
  - Completed: 2025-12-28

- [x] ~~**Phase 1: Data Models & Storage**~~ ✅ **COMPLETE**
  - ✅ Created Freezed models (Collar, Registration, Location)
  - ✅ Implemented local storage with SharedPreferences
  - ✅ All 28 unit tests passing
  - Completed: 2025-12-28

- [x] ~~**Phase 2: Backend API Integration**~~ ✅ **COMPLETE**
  - ✅ Created API client with all 3 endpoints
  - ✅ Comprehensive error handling (401, 404, 409, 500+)
  - ✅ All 12 integration tests passing
  - Completed: 2025-12-28

- [x] ~~**Phase 3: BLE Service Layer**~~ ✅ **COMPLETE**
  - ✅ BLE constants with Nordic UART UUIDs
  - ✅ BLE permissions handler (Android/iOS)
  - ✅ BLE service (scan, connect, send, receive)
  - ✅ BLE controller with Riverpod state management
  - ✅ All 22 BLE tests passing
  - Completed: 2025-12-28

### Critical Actions (This Week)

- [ ] **Start Phase 4: Collar Setup Wizard**
  - Implement QR scan screen with mobile_scanner
  - Build collar pairing flow with BLE
  - Create registration screens
  - Estimated: 3-5 days

---

## 📦 Phase 0: Foundation & Setup (Week 1)

### Package Installation
```bash
flutter pub add flutter_blue_plus mobile_scanner flutter_riverpod shared_preferences freezed_annotation json_annotation permission_handler

flutter pub add --dev build_runner freezed json_serializable flutter_lints
```

- [ ] Run `flutter pub add` commands
- [ ] Verify no version conflicts
- [ ] Run `flutter pub get`
- [ ] Test build on Android
- [ ] Test build on iOS

### Android Configuration
- [ ] Add Bluetooth permissions to `android/app/src/main/AndroidManifest.xml`
  ```xml
  <uses-permission android:name="android.permission.BLUETOOTH"/>
  <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
  <uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
  <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
  <uses-permission android:name="android.permission.CAMERA"/>
  ```
- [ ] Update `minSdkVersion` to 21 in `android/app/build.gradle`
- [ ] Test permissions request at runtime

### iOS Configuration
- [ ] Add permissions to `ios/Runner/Info.plist`
  ```xml
  <key>NSBluetoothAlwaysUsageDescription</key>
  <string>MyPerro needs Bluetooth to connect to your pet's collar</string>
  <key>NSBluetoothPeripheralUsageDescription</key>
  <string>MyPerro needs Bluetooth to communicate with the collar device</string>
  <key>NSCameraUsageDescription</key>
  <string>MyPerro needs camera access to scan the collar QR code</string>
  ```
- [ ] Update iOS deployment target to 12.0 in `ios/Podfile`
- [ ] Run `cd ios && pod install`

### Folder Structure
- [ ] Create `lib/core/ble/`
- [ ] Create `lib/core/api/`
- [ ] Create `lib/core/models/`
- [ ] Create `lib/core/storage/`
- [ ] Create `lib/core/config/`
- [ ] Create `lib/features/collar_setup/screens/`
- [ ] Create `lib/features/collar_setup/providers/`
- [ ] Create `lib/features/collar_setup/widgets/`
- [ ] Create `lib/utils/`

### Verification
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter run` works on Android device
- [ ] `flutter run` works on iOS device
- [ ] Git commit: "Phase 0: Foundation setup complete"

---

## 📝 Phase 1: Data Models (Week 1-2)

### Models to Create
- [ ] `lib/core/models/collar.dart`
  - Collar data model with Freezed
  - Fields: imei, collarToken, deviceName, petId, status, etc.

- [ ] `lib/core/models/registration.dart`
  - RegistrationRequest model
  - RegistrationResponse model
  - RegistrationStatus enum

- [ ] `lib/core/models/location_data.dart`
  - GPSCoordinate model
  - GPSTestResult model

- [ ] `lib/core/storage/app_storage.dart`
  - SharedPreferences wrapper
  - Save/get collar token
  - Save/get collar data

### Build Runner
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Verify generated files (`*.freezed.dart`, `*.g.dart`)
- [ ] Test JSON serialization/deserialization

### Testing
- [ ] Unit tests for Collar model
- [ ] Unit tests for Registration models
- [ ] Unit tests for Location models
- [ ] Unit tests for AppStorage
- [ ] Git commit: "Phase 1: Data models complete"

---

## 🌐 Phase 2: Backend API (Week 2)

- [ ] Create `lib/core/config/env.dart`
- [ ] Create `lib/core/api/api_client.dart`
- [ ] Implement `/register` endpoint
- [ ] Implement `/is_lost` endpoint
- [ ] Create `lib/core/api/api_service.dart` with Riverpod
- [ ] Add error handling
- [ ] Add retry logic
- [ ] Mock API server for testing
- [ ] Integration tests
- [ ] Git commit: "Phase 2: API integration complete"

---

## 📡 Phase 3: BLE Service (Week 3-4)

- [ ] Create `lib/core/ble/ble_constants.dart`
- [ ] Create `lib/core/ble/ble_permissions.dart`
- [ ] Create `lib/core/ble/ble_service.dart`
  - Scan for devices
  - Connect to device
  - Send commands
  - Receive responses
  - Disconnect
- [ ] Create `lib/core/ble/ble_controller.dart` with Riverpod
- [ ] Test with BLE simulator
- [ ] Unit tests with mock BLE
- [ ] Git commit: "Phase 3: BLE service complete"

---

## 📱 Phase 4: Collar Setup - QR & Pairing (Week 4-5)

- [ ] Create `lib/features/collar_setup/screens/qr_scan_collar_screen.dart`
- [ ] Create `lib/features/collar_setup/screens/collar_pairing_screen.dart`
- [ ] Create `lib/features/collar_setup/screens/collar_registration_screen.dart`
- [ ] Implement QR scanning with validation
- [ ] Implement BLE pairing flow
- [ ] Implement registration flow
- [ ] Add error handling
- [ ] Widget tests
- [ ] Git commit: "Phase 4: QR & Pairing complete"

---

## 📍 Phase 5: Geofence & GPS Test (Week 5-6)

- [ ] Create `lib/features/collar_setup/screens/geofence_setup_screen.dart`
- [ ] Create `lib/features/collar_setup/screens/gps_test_screen.dart`
- [ ] Create `lib/features/collar_setup/screens/setup_complete_screen.dart`
- [ ] Create `lib/utils/distance_calculator.dart`
- [ ] Implement geofence setup flow
- [ ] Implement GPS test flow
- [ ] Add coordinate comparison logic
- [ ] Widget tests
- [ ] Git commit: "Phase 5: Geofence & GPS complete"

---

## 🔗 Phase 6: Integration (Week 6-7)

- [ ] Update `lib/core/router/app_router.dart`
- [ ] Update `lib/ui/screens/onboarding/onboarding_done_screen.dart`
- [ ] Update `lib/ui/screens/profile/devices_screen.dart`
- [ ] Update `lib/ui/screens/dashboard_screens/dashboard_screen.dart`
- [ ] Integration tests
- [ ] Git commit: "Phase 6: Integration complete"

---

## 🧪 Phase 7: Testing & Refinement (Week 7-8)

- [ ] Unit tests (80%+ coverage)
- [ ] Widget tests
- [ ] Integration tests
- [ ] Manual testing on Android
- [ ] Manual testing on iOS
- [ ] Performance profiling
- [ ] Bug fixes
- [ ] UI/UX polish
- [ ] Git commit: "Phase 7: Testing complete - Ready for production"

---

## 📌 Parking Lot (Future Enhancements)

- [ ] Push notifications for lost mode
- [ ] Real-time location tracking
- [ ] Location history
- [ ] Share location with contacts
- [ ] Dark mode support
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Analytics integration

---

## 🐛 Known Issues

_No issues logged yet_

---

## 💡 Ideas & Improvements

_Add ideas here as they come up_

---

## 📅 Schedule

| Week | Phase | Status |
|------|-------|--------|
| Week 1 | Phase 0 + Phase 1 | ✅ COMPLETE (1 day) |
| Week 2 | Phase 2 | ✅ COMPLETE (1 day) |
| Week 3-4 | Phase 3 | ✅ COMPLETE (1 day) |
| Week 4-5 | Phase 4 | 🟡 In Progress |
| Week 5-6 | Phase 5 | 🔴 Not Started |
| Week 6-7 | Phase 6 | 🔴 Not Started |
| Week 7-8 | Phase 7 | 🔴 Not Started |

---

## 🎯 Today's Focus

**Date:** 2025-12-28

**Completed Today:**
1. ✅ Phase 0: Foundation & Setup (64 packages installed, permissions configured)
2. ✅ Phase 1: Data Models & Storage (28 tests passing)
3. ✅ Phase 2: Backend API Integration (12 tests passing)
4. ✅ Phase 3: BLE Service Layer (22 tests passing)

**Total:** 62/62 tests passing (100%)

**What's Working:**
- Complete BLE communication layer with Nordic UART Service
- Full API client with all 3 endpoints
- Comprehensive data models with Freezed
- Local storage with SharedPreferences
- Riverpod state management throughout

**Ready For:**
- Phase 4: Collar Setup Wizard (QR scanning + pairing screens)

**Notes:**
- All core backend functionality complete
- BLE service ready for real collar testing
- Next step: Build UI screens for collar setup flow
