# FindMyPerro - Implementation Roadmap

> **Last Updated:** 2025-12-28
> **Overall Completion:** 40% (Phase 0-3 complete + BLE functionality)
> **Current Phase:** Phase 4 - Collar Setup Wizard (READY TO START)

---

## 📊 Project Status Overview

| Category | Status | Progress |
|----------|--------|----------|
| **UI/UX Screens** | ✅ Complete | 80% |
| **Pet Registration** | ✅ Complete | 100% |
| **GPS/Location** | ✅ Complete | 100% |
| **BLE Communication** | ✅ Complete | 100% |
| **QR Code Scanning** | ⚠️ UI Only | 5% |
| **Backend API** | ✅ Complete | 100% |
| **Collar Setup Wizard** | ❌ Not Started | 0% |
| **Overall** | 🟡 In Progress | 40% |

---

## 🎯 SRS Requirements Mapping

### App Requirements vs Implementation Status

| # | Requirement | Status | File/Component | Priority |
|---|-------------|--------|----------------|----------|
| 1 | User fills pet details form | ✅ **DONE** | `onboarding_pet_credentials_screen.dart` | - |
| 2 | Scan QR code (15-digit IMEI) | ⚠️ **UI ONLY** | `qr_scanner_screen.dart` (needs mobile_scanner) | **CRITICAL** |
| 3 | Enable Bluetooth & search BLE | ✅ **DONE** | `core/ble/ble_service.dart` + permissions | - |
| 4 | Connect to collar (Nordic UART) | ✅ **DONE** | `core/ble/ble_service.dart` | - |
| 5 | Send "Send IMEI" via BLE | ✅ **DONE** | `BleService.requestImei()` | - |
| 6 | Receive Collar IMEI via BLE | ✅ **DONE** | `BleService.requestImei()` | - |
| 7 | Compare User vs Collar IMEI | ⚠️ **PARTIAL** | BLE logic ready, needs UI integration | **HIGH** |
| 8 | POST /register endpoint | ✅ **DONE** | `core/api/api_client.dart` | - |
| 9 | Handle registration responses | ✅ **DONE** | `RegistrationResponse` with Cases A/B/C | - |
| 10 | Send "CollarToken:<token>" | ✅ **DONE** | `BleService.sendCollarToken()` | - |
| 11 | Geofence setup UI | ❌ **MISSING** | `geofence_setup_screen.dart` | **HIGH** |
| 12 | Send "set geofence" via BLE | ✅ **DONE** | `BleService.setupGeofence()` | - |
| 13 | Wait for "Geofence is set" | ✅ **DONE** | `BleService.setupGeofence()` | - |
| 14 | GPS test UI | ❌ **MISSING** | `gps_test_screen.dart` | **HIGH** |
| 15 | Send "start GPS Test" | ✅ **DONE** | `BleService.startGpsTest()` | - |
| 16 | Receive collar GPS coords | ✅ **DONE** | `BleService.startGpsTest()` + parser | - |
| 17 | Get phone GPS coordinates | ✅ **DONE** | `core/location/location_service.dart` | - |
| 18 | Compare coords (20m/50m) | ⚠️ **PARTIAL** | `GPSTestResult` model ready, needs UI | **HIGH** |
| 19 | Send verification result | ✅ **DONE** | `BleService.notifyLocationVerified/Failed()` | - |

**Progress:** 14 of 19 requirements complete (74%)

---

## 🏗️ Architecture Status

### Core Components (✅ Complete)

```
lib/
├── core/
│   ├── ble/                           ✅ COMPLETE
│   │   ├── ble_service.dart          # BLE communication layer
│   │   ├── ble_controller.dart       # State management
│   │   ├── ble_constants.dart        # Nordic UART UUIDs
│   │   └── ble_permissions.dart      # Permission handling
│   │
│   ├── api/                           ✅ COMPLETE
│   │   ├── api_client.dart           # HTTP client wrapper
│   │   ├── api_service.dart          # API service layer
│   │   └── endpoints.dart            # API endpoints
│   │
│   ├── models/                        ✅ COMPLETE
│   │   ├── collar.dart               # Collar data model
│   │   ├── registration.dart         # Registration models
│   │   └── location_data.dart        # GPS coordinate models
│   │
│   ├── storage/                       ✅ COMPLETE
│   │   └── app_storage.dart          # Local storage service
│   │
│   └── config/                        ✅ COMPLETE
│       └── env.dart                   # Environment config
│
├── features/
│   └── collar_setup/                  ❌ MISSING (CRITICAL)
│       ├── screens/
│       │   ├── qr_scan_collar_screen.dart
│       │   ├── collar_pairing_screen.dart
│       │   ├── collar_registration_screen.dart
│       │   ├── geofence_setup_screen.dart
│       │   ├── gps_test_screen.dart
│       │   └── setup_complete_screen.dart
│       │
│       ├── providers/
│       │   └── collar_setup_provider.dart
│       │
│       └── widgets/
│           └── pairing_step_indicator.dart
│
└── utils/
    └── distance_calculator.dart       ❌ MISSING (HIGH)
```

### Missing Packages

| Package | Version | Purpose | Priority |
|---------|---------|---------|----------|
| `flutter_blue_plus` | ^1.32.0 | BLE communication | **CRITICAL** |
| `mobile_scanner` | ^5.0.0 | QR code scanning | **CRITICAL** |
| `flutter_riverpod` | ^2.5.0 | State management | **HIGH** |
| `shared_preferences` | ^2.2.0 | Local storage | **HIGH** |
| `freezed` | ^2.4.0 | Data models | **HIGH** |
| `freezed_annotation` | ^2.4.0 | Data models | **HIGH** |
| `json_annotation` | ^4.8.0 | JSON serialization | **HIGH** |
| `permission_handler` | ^11.0.0 | Runtime permissions | **MEDIUM** |

---

## 📅 Phased Implementation Plan

### ✅ Phase 0: Foundation & Setup (Week 1)
**Status:** 🟢 **COMPLETE** (Completed: 2025-12-28)
**Goal:** Set up core dependencies and architecture

#### Tasks
- [x] **0.1** Install packages (flutter_blue_plus, mobile_scanner, riverpod, etc.)
- [x] **0.2** Configure Android Bluetooth permissions in `AndroidManifest.xml`
- [x] **0.3** Configure iOS Bluetooth permissions in `Info.plist`
- [x] **0.4** Create folder structure (`core/ble`, `core/api`, `features/collar_setup`, etc.)
- [x] **0.5** Verify build runs without errors on Android & iOS
- [x] **0.6** Set up Riverpod providers

**Deliverables:**
- [x] All packages installed & compatible (64 new packages added)
- [x] Permissions configured (Android + iOS)
- [x] Folder structure created with .gitkeep files
- [x] Build analysis successful (171 linting warnings - non-blocking)

**Actual Time:** 1 day

---

### ✅ Phase 1: Data Models & Storage (Week 1-2)
**Status:** 🟢 **COMPLETE** (Completed: 2025-12-28)
**Depends On:** Phase 0
**Goal:** Define data structures and persistence layer

#### Tasks
- [x] **1.1** Create `Collar` model with Freezed (`core/models/collar.dart`)
- [x] **1.2** Create `RegistrationRequest` & `RegistrationResponse` models (`core/models/registration.dart`)
- [x] **1.3** Create `GPSCoordinate` & `GPSTestResult` models (`core/models/location_data.dart`)
- [x] **1.4** Implement `AppStorage` service with SharedPreferences (`core/storage/app_storage.dart`)
- [x] **1.5** Run `build_runner` to generate Freezed code
- [x] **1.6** Write unit tests for all models

**Key Files:**
- ✅ `lib/core/models/collar.dart` - Collar data model with 7 status states
- ✅ `lib/core/models/registration.dart` - Registration request/response with 3 status types
- ✅ `lib/core/models/location_data.dart` - GPS coordinate models with extensions
- ✅ `lib/core/storage/app_storage.dart` - Local storage service with collar management

**Deliverables:**
- [x] All models defined with Freezed (3 model files created)
- [x] JSON serialization working (9 generated files from build_runner)
- [x] Local storage service functional (complete CRUD operations)
- [x] Unit tests passing - **28/28 tests passed (100%)**

**Actual Time:** 1 day

---

### ✅ Phase 2: Backend API Integration (Week 2)
**Status:** 🟢 **COMPLETE** (Completed: 2025-12-28)
**Depends On:** Phase 0, Phase 1
**Goal:** Implement backend communication layer

#### Tasks
- [x] **2.1** Create `ApiClient` class (`core/api/api_client.dart`)
- [x] **2.2** Implement `/register` POST endpoint
- [x] **2.3** Implement `/is_lost` POST endpoint
- [x] **2.4** Create `ApiService` with Riverpod (`core/api/api_service.dart`)
- [x] **2.5** Create environment configuration (`core/config/env.dart`)
- [x] **2.6** Add error handling and retry logic
- [x] **2.7** Write integration tests with mock server

**Key Files:**
- ✅ `lib/core/api/api_client.dart` - HTTP client wrapper with full error handling
- ✅ `lib/core/api/api_service.dart` - API service layer with Riverpod providers
- ✅ `lib/core/config/env.dart` - Environment configuration with defaults

**API Endpoints Implemented:**
```dart
✅ POST /register - Handles Cases A, B, C
✅ POST /is_lost - Update collar lost status
✅ POST /location - Send lost mode locations
```

**Error Handling:**
- ✅ Network errors (SocketException)
- ✅ Timeouts (configurable via env)
- ✅ HTTP status codes (401, 404, 409, 500+)
- ✅ JSON parsing errors
- ✅ Custom ApiException with status codes

**Deliverables:**
- [x] API client with comprehensive error handling
- [x] All 3 endpoints integrated
- [x] Environment configuration with dev/prod modes
- [x] Integration tests passing - **12/12 tests passed (100%)**

**Actual Time:** 1 day

---

### ✅ Phase 3: BLE Service Layer (Week 3-4)
**Status:** ✅ COMPLETE
**Depends On:** Phase 0, Phase 1
**Goal:** Implement complete Bluetooth Low Energy communication

#### Tasks
- [x] **3.1** Create BLE constants (Nordic UART UUIDs) (`core/ble/ble_constants.dart`)
- [x] **3.2** Implement `BleService` with scan, connect, send, receive (`core/ble/ble_service.dart`)
- [x] **3.3** Create `BleController` with Riverpod state management (`core/ble/ble_controller.dart`)
- [x] **3.4** Implement `BlePermissions` handler (`core/ble/ble_permissions.dart`)
- [x] **3.5** Add BLE device discovery logic
- [x] **3.6** Add command send/receive with timeout
- [x] **3.7** Write unit tests with mock BLE device

**Key Files:**
- `lib/core/ble/ble_constants.dart` - BLE UUIDs and commands
- `lib/core/ble/ble_service.dart` - Core BLE communication
- `lib/core/ble/ble_controller.dart` - State management
- `lib/core/ble/ble_permissions.dart` - Permission handling

**BLE Protocol:**
```dart
// Nordic UART Service UUIDs
Service:  6E400001-B5A3-F393-E0A9-E50E24DCCA9E
RX (Write): 6E400002-B5A3-F393-E0A9-E50E24DCCA9E
TX (Notify): 6E400003-B5A3-F393-E0A9-E50E24DCCA9E

// Commands (App → Collar)
"Send IMEI"
"CollarToken:<token>"
"set geofence"
"start GPS Test"
"location Verified"
"Test failed"

// Responses (Collar → App)
"<15-digit IMEI>"
"Geofence is set"
"<lat>,<long>"
```

**Deliverables:**
- [x] BLE service with Nordic UART support
- [x] Scan, connect, disconnect working
- [x] Command send/receive functional
- [x] Permission handling complete
- [x] BLE state management with Riverpod
- [x] Unit tests passing - **22/22 tests passed (100%)**

**Actual Time:** 1 day

**✅ SUCCESS:** Complete BLE communication layer with comprehensive error handling, state management, and all Nordic UART commands implemented.

---

### ⬜ Phase 4: Collar Setup Wizard - QR & Pairing (Week 4-5)
**Status:** 🔴 Not Started
**Depends On:** Phase 1, Phase 2, Phase 3
**Goal:** Build collar scanning and initial pairing flow

#### Tasks
- [ ] **4.1** Implement QR scan screen with `mobile_scanner` (`qr_scan_collar_screen.dart`)
- [ ] **4.2** Add IMEI validation (15-digit numeric)
- [ ] **4.3** Create collar pairing screen (`collar_pairing_screen.dart`)
- [ ] **4.4** Implement BLE scan for device with IMEI name
- [ ] **4.5** Add IMEI comparison logic (User vs Collar)
- [ ] **4.6** Create registration screen (`collar_registration_screen.dart`)
- [ ] **4.7** Implement 3 registration response handlers (A/B/C)
- [ ] **4.8** Add collar token transmission via BLE
- [ ] **4.9** Create pairing step indicator widget
- [ ] **4.10** Add error handling and retry logic

**New Screens:**
- `lib/features/collar_setup/screens/qr_scan_collar_screen.dart`
- `lib/features/collar_setup/screens/collar_pairing_screen.dart`
- `lib/features/collar_setup/screens/collar_registration_screen.dart`

**User Flow:**
```
1. QR Scan Screen → Scan 15-digit IMEI
2. Pairing Screen → Auto-scan for BLE device
3. Pairing Screen → Send "Send IMEI" → Receive Collar IMEI
4. Pairing Screen → Compare IMEIs (retry if mismatch)
5. Registration Screen → POST /register
6. Registration Screen → Handle response (A/B/C)
7. Registration Screen → Send "CollarToken:<token>"
8. Navigate to Geofence Setup
```

**Deliverables:**
- [ ] QR scanning with validation working
- [ ] BLE scan & connect flow complete
- [ ] IMEI verification logic functional
- [ ] Backend registration integrated
- [ ] Error handling & retry logic
- [ ] All screens with proper loading states

**Estimated Time:** 4-5 days

---

### ⬜ Phase 5: Collar Setup Wizard - Geofence & GPS Test (Week 5-6)
**Status:** 🔴 Not Started
**Depends On:** Phase 1, Phase 2, Phase 3, Phase 4
**Goal:** Complete collar setup with geofence and GPS verification

#### Tasks
- [ ] **5.1** Create geofence setup screen (`geofence_setup_screen.dart`)
- [ ] **5.2** Add "Set as Geofence" button with BLE command
- [ ] **5.3** Wait for "Geofence is set" response
- [ ] **5.4** Create GPS test screen (`gps_test_screen.dart`)
- [ ] **5.5** Add "Start GPS Test" button with BLE command
- [ ] **5.6** Implement coordinate parsing from BLE
- [ ] **5.7** Create distance calculator utility (Haversine formula)
- [ ] **5.8** Add coordinate comparison logic (20m/50m thresholds)
- [ ] **5.9** Implement verification/failure response logic
- [ ] **5.10** Create setup complete screen (`setup_complete_screen.dart`)
- [ ] **5.11** Add test retry logic (max 3 attempts)

**New Screens:**
- `lib/features/collar_setup/screens/geofence_setup_screen.dart`
- `lib/features/collar_setup/screens/gps_test_screen.dart`
- `lib/features/collar_setup/screens/setup_complete_screen.dart`

**New Utilities:**
- `lib/utils/distance_calculator.dart` - Haversine distance calculation

**User Flow:**
```
1. Geofence Setup Screen → Instructions to walk to boundary
2. Geofence Setup Screen → "Set as Geofence" button
3. Geofence Setup Screen → Send "set geofence" → Wait for response
4. GPS Test Screen → Instructions to go to open area
5. GPS Test Screen → "Start GPS Test" button
6. GPS Test Screen → Send "start GPS Test" → Wait for coordinates
7. GPS Test Screen → Get phone GPS → Calculate distance
8. GPS Test Screen → Verify (≤20m) or Retry (≤50m after 2-3 attempts)
9. GPS Test Screen → Send "location Verified" or "Test failed"
10. Setup Complete Screen → Success message
```

**Verification Logic:**
- ✅ Distance ≤ 20m → Immediate verification
- ✅ Distance ≤ 50m after 2-3 attempts → Verification
- ❌ Distance > 50m → Test failed, retry

**Deliverables:**
- [ ] Geofence setup with instructions
- [ ] GPS test with coordinate comparison
- [ ] Distance calculator utility
- [ ] Setup complete screen
- [ ] Complete wizard navigation
- [ ] Error handling & retry logic
- [ ] UI/UX polished

**Estimated Time:** 4-5 days

---

### ⬜ Phase 6: Integration & Navigation (Week 6-7)
**Status:** 🔴 Not Started
**Depends On:** Phase 4, Phase 5
**Goal:** Connect collar setup to existing app flow

#### Tasks
- [ ] **6.1** Update `AppRouter` with collar setup routes
- [ ] **6.2** Add entry point from onboarding completion
- [ ] **6.3** Add "Add Collar" button in devices screen
- [ ] **6.4** Update dashboard to show collar status
- [ ] **6.5** Integrate collar data with local storage
- [ ] **6.6** Add collar list in devices screen
- [ ] **6.7** Update device detail screen with real data
- [ ] **6.8** Add deep linking for collar setup
- [ ] **6.9** Test end-to-end navigation flow
- [ ] **6.10** Update app state management

**Files to Update:**
- `lib/core/router/app_router.dart` - Add routes
- `lib/ui/screens/onboarding/onboarding_done_screen.dart` - Add entry point
- `lib/ui/screens/profile/devices_screen.dart` - Add "Add Collar" button
- `lib/ui/screens/dashboard_screens/dashboard_screen.dart` - Show collar status
- `lib/ui/screens/profile/device_detail_screen.dart` - Real data integration

**Deliverables:**
- [ ] Updated routing with all screens
- [ ] Integration with onboarding flow
- [ ] Integration with devices screen
- [ ] Dashboard showing collar status
- [ ] End-to-end flow testing complete

**Estimated Time:** 3-4 days

---

### ⬜ Phase 7: Testing & Refinement (Week 7-8)
**Status:** 🔴 Not Started
**Depends On:** All previous phases
**Goal:** Comprehensive testing and bug fixes

#### Tasks
- [ ] **7.1** Write unit tests for all models
- [ ] **7.2** Write unit tests for BLE service
- [ ] **7.3** Write unit tests for API client
- [ ] **7.4** Write widget tests for all screens
- [ ] **7.5** Write integration tests for collar setup flow
- [ ] **7.6** Test with real collar device
- [ ] **7.7** Test on multiple Android devices
- [ ] **7.8** Test on iOS devices
- [ ] **7.9** Performance profiling and optimization
- [ ] **7.10** Fix all critical bugs
- [ ] **7.11** UI/UX polish and animations
- [ ] **7.12** Accessibility testing
- [ ] **7.13** Battery drain testing
- [ ] **7.14** Network failure scenarios
- [ ] **7.15** Code review and refactoring

**Testing Checklist:**
- [ ] QR code scanning with real QR codes
- [ ] Bluetooth permissions on Android & iOS
- [ ] BLE connection with real collar
- [ ] Geofence setup in various locations
- [ ] GPS test in open area
- [ ] GPS test indoors (graceful failure)
- [ ] Network failures during registration
- [ ] Bluetooth disconnection mid-setup
- [ ] Battery drain acceptable (<5% per hour)
- [ ] App doesn't crash on errors
- [ ] Loading states display correctly
- [ ] Error messages are user-friendly

**Deliverables:**
- [ ] 80%+ code coverage
- [ ] All critical paths tested
- [ ] Bug list documented and fixed
- [ ] Performance profiling complete
- [ ] App ready for beta testing

**Estimated Time:** 5-7 days

---

### ⬜ Phase 8: Backend Lost Mode (Future Enhancement)
**Status:** 🔴 Not Started
**Depends On:** Phase 7 (Production release)
**Goal:** Implement lost mode detection and tracking

#### Tasks
- [ ] **8.1** Implement `/is_lost` endpoint integration
- [ ] **8.2** Create push notification handler
- [ ] **8.3** Build lost mode notification screen
- [ ] **8.4** Create real-time tracking map
- [ ] **8.5** Add location history timeline
- [ ] **8.6** Implement "Mark as Found" functionality
- [ ] **8.7** Add emergency contact sharing
- [ ] **8.8** Background location updates
- [ ] **8.9** Battery optimization for tracking

**New Features:**
- Push notifications when collar flags as lost
- Real-time map showing pet location
- Location history with timestamps
- Share location with contacts
- Mark as found to disable tracking

**Deliverables:**
- [ ] Lost mode notifications working
- [ ] Real-time tracking UI complete
- [ ] Location history functional
- [ ] Backend integration complete

**Estimated Time:** 5-7 days

---

## 🚧 Blockers & Dependencies

### Current Blockers
1. **Collar Firmware BLE Protocol** - Need detailed specification document
2. **Backend API** - `/register` and `/is_lost` endpoints must be implemented
3. **BLE Test Device** - Need physical collar or BLE simulator for testing

### External Dependencies
- Backend team: API endpoints
- Hardware team: Collar firmware with BLE
- Design team: Final UI/UX review

---

## ⚠️ Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| BLE library compatibility | Medium | High | Test flutter_blue_plus early on target devices |
| Collar firmware delays | High | Critical | Request protocol docs NOW, create mock device |
| Backend API not ready | High | High | Use mock API server (json-server or mockoon) |
| GPS accuracy issues | Medium | High | Set realistic thresholds, test in various conditions |
| Bluetooth permissions rejection | Low | Medium | Clear UI explanation, graceful handling |
| QR scanning performance | Low | Low | mobile_scanner is proven, fallback to manual entry |

---

## 📋 Success Criteria

### Phase Completion Criteria
✅ All deliverables checked off
✅ Unit tests passing with >70% coverage
✅ Integration tests passing
✅ Manual testing completed
✅ Code review approved
✅ Documentation updated

### Final Release Criteria
✅ Complete collar setup flow working
✅ BLE communication stable
✅ Backend registration functional
✅ GPS verification accurate (≤20m)
✅ Error handling comprehensive
✅ Performance benchmarks met (<5 min setup)
✅ Tested on Android & iOS
✅ User acceptance testing passed

---

## 📝 Development Notes

### BLE Nordic UART UUIDs
```
Service:     6E400001-B5A3-F393-E0A9-E50E24DCCA9E
RX (Write):  6E400002-B5A3-F393-E0A9-E50E24DCCA9E
TX (Notify): 6E400003-B5A3-F393-E0A9-E50E24DCCA9E
```

### API Endpoints
```
POST https://api.myperro.com/register
POST https://api.myperro.com/is_lost
```

### Distance Thresholds
- Immediate verification: ≤ 20m
- Fallback verification: ≤ 50m (after 2-3 attempts)
- Test failure: > 50m

---

## 🔄 Change Log

### 2025-12-28
- Initial roadmap created
- SRS requirements mapped to implementation
- 8-phase development plan defined
- Current status: 10% complete (2/19 requirements)

---

## 📞 Team Contacts

**Development Team:**
- App Developer: [Your Name]
- Backend Team: [Contact]
- Hardware/Firmware Team: [Contact]
- QA Team: [Contact]

**Next Review Date:** [To be scheduled]

---

## 🎯 Next Immediate Actions

1. ✅ **DONE:** Created comprehensive roadmap
2. ⬜ **TODO:** Get collar firmware BLE protocol documentation
3. ⬜ **TODO:** Set up development environment for Phase 0
4. ⬜ **TODO:** Create mock collar device for testing
5. ⬜ **TODO:** Finalize backend API contract with team
6. ⬜ **TODO:** Start Phase 0 - Install packages and configure permissions

---

**Total Estimated Time:** 8-12 weeks (1 developer, assuming collar firmware ready)
**Current Progress:** Week 0 - Planning Complete
**Target Completion:** Week 12
