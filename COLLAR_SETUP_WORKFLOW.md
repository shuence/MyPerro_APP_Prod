# Collar Setup Workflow - Quick Reference

> **Visual guide for the complete collar pairing and setup process**

---

## 🔄 Complete User Journey

```
┌─────────────────────────────────────────────────────────────────┐
│                    ONBOARDING COMPLETE                          │
│                  (Pet Details Registered)                       │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: QR CODE SCANNING                                        │
│ Screen: qr_scan_collar_screen.dart                              │
├─────────────────────────────────────────────────────────────────┤
│ • User opens collar box                                         │
│ • Scans QR code on collar packaging                            │
│ • QR code contains 15-digit IMEI                               │
│ • Validate: Must be exactly 15 numeric digits                  │
│                                                                 │
│ Input:  None                                                    │
│ Output: userIMEI (15-digit string)                             │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: BLUETOOTH PAIRING                                       │
│ Screen: collar_pairing_screen.dart                              │
├─────────────────────────────────────────────────────────────────┤
│ • App turns on Bluetooth                                        │
│ • Scan for BLE devices                                          │
│ • Find device with name matching userIMEI                      │
│ • Connect to device                                             │
│ • Configure Nordic UART Service (UUIDs)                        │
│                                                                 │
│ BLE Setup:                                                      │
│ ├─ Service:  6E400001-B5A3-F393-E0A9-E50E24DCCA9E             │
│ ├─ RX (Write):  6E400002-B5A3-F393-E0A9-E50E24DCCA9E          │
│ └─ TX (Notify): 6E400003-B5A3-F393-E0A9-E50E24DCCA9E          │
│                                                                 │
│ Input:  userIMEI                                                │
│ Output: BLE connection established                             │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: IMEI VERIFICATION                                       │
│ Screen: collar_pairing_screen.dart (continued)                  │
├─────────────────────────────────────────────────────────────────┤
│ App → Collar:  "Send IMEI"                                      │
│ Collar → App:  "<15-digit IMEI>"  (collarIMEI)                 │
│                                                                 │
│ Validation:                                                     │
│ IF userIMEI == collarIMEI:                                      │
│   ✅ Continue to registration                                   │
│ ELSE:                                                           │
│   ❌ Disconnect, rescan for correct device                      │
│                                                                 │
│ Input:  userIMEI, BLE connection                                │
│ Output: collarIMEI (verified)                                   │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 4: BACKEND REGISTRATION                                    │
│ Screen: collar_registration_screen.dart                         │
├─────────────────────────────────────────────────────────────────┤
│ POST https://api.myperro.com/register                          │
│                                                                 │
│ Request Body:                                                   │
│ {                                                               │
│   "imei": "<userIMEI>",                                         │
│   "userId": "<current_user_id>",                                │
│   "userToken": "<auth_token>"                                   │
│ }                                                               │
│                                                                 │
│ Response (3 possible cases):                                    │
│                                                                 │
│ Case A - Already Registered (Current User):                    │
│ {                                                               │
│   "status": "alreadyRegisteredCurrentUser",                     │
│   "collarToken": "abc123...",                                   │
│   "message": "Collar already registered to you"                 │
│ }                                                               │
│ ✅ Continue to next step                                        │
│                                                                 │
│ Case B - Already Registered (Other User):                      │
│ {                                                               │
│   "status": "alreadyRegisteredOtherUser",                       │
│   "message": "Collar registered to another user"                │
│ }                                                               │
│ ❌ Show error, contact support                                  │
│                                                                 │
│ Case C - Newly Registered:                                      │
│ {                                                               │
│   "status": "newlyRegistered",                                  │
│   "collarToken": "xyz789...",                                   │
│   "message": "Collar successfully registered"                   │
│ }                                                               │
│ ✅ Continue to next step                                        │
│                                                                 │
│ Input:  userIMEI, userId, userToken                             │
│ Output: collarToken (for Cases A & C)                           │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 5: TOKEN TRANSMISSION                                      │
│ Screen: collar_registration_screen.dart (continued)             │
├─────────────────────────────────────────────────────────────────┤
│ App → Collar:  "CollarToken:<collarToken>"                      │
│                                                                 │
│ Wait 5 seconds for collar to process                           │
│                                                                 │
│ Input:  collarToken                                             │
│ Output: None (collar stores token internally)                   │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 6: GEOFENCE SETUP                                          │
│ Screen: geofence_setup_screen.dart                              │
├─────────────────────────────────────────────────────────────────┤
│ Instructions to User:                                           │
│ "Walk to the exit point you want to use as your home boundary. │
│  Stand at that spot and click 'Set as Geofence'."              │
│                                                                 │
│ User Action:                                                    │
│ 1. Walk to home boundary/exit point                            │
│ 2. Click "Set This as My Geofence" button                      │
│                                                                 │
│ App → Collar:  "set geofence"                                   │
│                                                                 │
│ Collar Actions:                                                 │
│ 1. Measure current WiFi RSSI                                    │
│ 2. Save as GOUT (geofence out threshold)                       │
│ 3. Calculate GIN = GOUT + 10                                    │
│ 4. Save GIN (geofence in threshold)                             │
│                                                                 │
│ Collar → App:  "Geofence is set"                                │
│                                                                 │
│ Input:  User at boundary location                               │
│ Output: Geofence configured in collar                           │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 7: GPS VERIFICATION TEST                                   │
│ Screen: gps_test_screen.dart                                    │
├─────────────────────────────────────────────────────────────────┤
│ Instructions to User:                                           │
│ "Go to an open area with clear sky view.                       │
│  Avoid balconies, windows, or covered areas."                  │
│                                                                 │
│ User Action:                                                    │
│ 1. Go to open area                                              │
│ 2. Click "Start GPS Test" button                               │
│                                                                 │
│ App → Collar:  "start GPS Test"                                 │
│                                                                 │
│ Collar Actions:                                                 │
│ 1. Wake up Quectel EC200U-CN from sleep                        │
│ 2. Turn on GPS                                                  │
│ 3. Wait for GPS fix                                             │
│ 4. Ping 4 times (t=0, t=1, t=2, t=3)                           │
│ 5. Take last reading (4th ping)                                │
│                                                                 │
│ Collar → App:  "<latitude>,<longitude>"                         │
│                                                                 │
│ App Actions:                                                    │
│ 1. Parse collar coordinates                                     │
│ 2. Get phone GPS coordinates                                    │
│ 3. Calculate distance (Haversine formula)                       │
│                                                                 │
│ Verification Logic:                                             │
│                                                                 │
│ IF distance <= 20 meters:                                       │
│   ✅ App → Collar: "location Verified"                          │
│   ✅ Proceed to completion                                      │
│                                                                 │
│ ELSE IF (attempts >= 2 OR attempts >= 3) AND distance <= 50m:  │
│   ✅ App → Collar: "location Verified"                          │
│   ✅ Proceed to completion                                      │
│                                                                 │
│ ELSE:                                                           │
│   ❌ App → Collar: "Test failed"                                │
│   ❌ Retry test (max 3 attempts)                                │
│                                                                 │
│ Input:  User in open area                                       │
│ Output: GPS verified or test retry                              │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│ STEP 8: SETUP COMPLETE                                          │
│ Screen: setup_complete_screen.dart                              │
├─────────────────────────────────────────────────────────────────┤
│ Collar Actions:                                                 │
│ 1. Turn off BLE advertising                                     │
│ 2. Put Quectel EC200U-CN to sleep                              │
│ 3. Enter NORMAL OPERATION MODE                                  │
│                                                                 │
│ App Actions:                                                    │
│ 1. Save collar data to local storage                           │
│ 2. Show success screen                                          │
│ 3. Navigate to dashboard                                        │
│                                                                 │
│ Normal Operation Mode (Collar):                                 │
│ • Check WiFi RSSI every 3 seconds                              │
│ • IF RSSI < GOUT:                                               │
│   → Flag as "chances of being lost"                            │
│   → Wake up Quectel                                             │
│   → Start GPS                                                   │
│   → Try to get location within 2.5 minutes                     │
│   → IF location obtained:                                       │
│     • Flag collar as LOST                                       │
│     • POST /is_lost with "true"                                 │
│     • Enter LOST MODE                                           │
│   → IF location NOT obtained:                                   │
│     • Put Quectel back to sleep                                 │
│     • Continue normal operation                                 │
│                                                                 │
│ Output: Collar ready for use                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📡 BLE Communication Protocol

### Nordic UART Service UUIDs
```
Service UUID:      6E400001-B5A3-F393-E0A9-E50E24DCCA9E
RX Characteristic: 6E400002-B5A3-F393-E0A9-E50E24DCCA9E (Write - App to Collar)
TX Characteristic: 6E400003-B5A3-F393-E0A9-E50E24DCCA9E (Notify - Collar to App)
```

### Commands (App → Collar)
| Command | Purpose | Expected Response |
|---------|---------|-------------------|
| `Send IMEI` | Request collar IMEI | `<15-digit IMEI>` |
| `CollarToken:<token>` | Send backend token to collar | None (collar stores) |
| `set geofence` | Trigger geofence setup | `Geofence is set` |
| `start GPS Test` | Start GPS verification | `<lat>,<long>` |
| `location Verified` | Confirm GPS test passed | None |
| `Test failed` | GPS test failed, retry | None (collar retries) |

### Responses (Collar → App)
| Response | Meaning |
|----------|---------|
| `<15-digit IMEI>` | Collar's IMEI number |
| `Geofence is set` | Geofence configuration complete |
| `<lat>,<long>` | GPS coordinates (e.g., "12.9716,77.5946") |

---

## 🔍 Key Validation Points

### IMEI Validation
```dart
bool isValidIMEI(String imei) {
  return imei.length == 15 &&
         RegExp(r'^\d{15}$').hasMatch(imei);
}
```

### Distance Calculation (Haversine)
```dart
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000; // Earth radius in meters
  final dLat = toRadians(lat2 - lat1);
  final dLon = toRadians(lon2 - lon1);

  final a = sin(dLat/2) * sin(dLat/2) +
            cos(toRadians(lat1)) * cos(toRadians(lat2)) *
            sin(dLon/2) * sin(dLon/2);

  final c = 2 * atan2(sqrt(a), sqrt(1-a));
  return R * c;
}
```

### GPS Verification Logic
```dart
bool verifyGPSLocation(double distance, int attemptNumber) {
  if (distance <= 20) {
    return true; // Immediate pass
  }

  if ((attemptNumber >= 2 || attemptNumber >= 3) && distance <= 50) {
    return true; // Fallback pass
  }

  return false; // Retry
}
```

---

## 🚨 Error Handling

### QR Scan Errors
- ❌ **Invalid QR code format** → "Please scan the QR code from the collar box"
- ❌ **Wrong barcode type** → "This is not a valid collar QR code"

### BLE Connection Errors
- ❌ **Device not found** → "Collar not found. Make sure collar is powered on"
- ❌ **Connection timeout** → "Failed to connect. Please try again"
- ❌ **IMEI mismatch** → "Device mismatch. Searching for correct collar..."

### Registration Errors
- ❌ **Network error** → "Connection failed. Check your internet"
- ❌ **Already registered (other user)** → "This collar is registered to another account. Contact support"
- ❌ **Server error** → "Registration failed. Please try again"

### Geofence Errors
- ❌ **BLE disconnected** → "Connection lost. Reconnecting..."
- ❌ **Timeout waiting for response** → "Geofence setup failed. Please retry"

### GPS Test Errors
- ❌ **No GPS fix** → "GPS signal not found. Move to an open area"
- ❌ **Phone GPS disabled** → "Please enable location services"
- ❌ **Distance too far** → "Distance: Xm. Please ensure both devices are together"
- ❌ **Max retries exceeded** → "GPS test failed after 3 attempts. Contact support"

---

## 📊 State Flow Diagram

```
[QR Scan]
    ↓ (userIMEI)
[BLE Scan]
    ↓ (device found)
[BLE Connect]
    ↓ (connected)
[Send "Send IMEI"]
    ↓ (collarIMEI)
[Verify IMEI] ──→ [Mismatch] ──→ [Disconnect & Rescan]
    ↓ (match)
[POST /register] ──→ [Case B Error] ──→ [Show Error Screen]
    ↓ (Case A or C)
[Send CollarToken]
    ↓ (wait 5s)
[Navigate to Geofence]
    ↓ (user at boundary)
[Send "set geofence"]
    ↓ ("Geofence is set")
[Navigate to GPS Test]
    ↓ (user in open area)
[Send "start GPS Test"]
    ↓ (lat,long)
[Get Phone GPS]
    ↓ (calculate distance)
[Verify Distance] ──→ [Distance > 50m] ──→ [Send "Test failed"] ──→ [Retry]
    ↓ (≤20m or ≤50m after 2-3 tries)
[Send "location Verified"]
    ↓
[Setup Complete]
    ↓
[Dashboard]
```

---

## 🔧 Troubleshooting Guide

### "Device not found" during BLE scan
1. Ensure collar is powered on
2. Check Bluetooth is enabled on phone
3. Ensure IMEI matches exactly
4. Try rescanning QR code

### "Connection timeout"
1. Move phone closer to collar
2. Ensure no other apps are using Bluetooth
3. Restart phone Bluetooth
4. Retry pairing

### "Registration failed"
1. Check internet connection
2. Verify user is logged in
3. Check backend API is running
4. Retry registration

### "Geofence setup failed"
1. Ensure BLE connection is stable
2. Move closer to collar
3. Retry setup
4. Check collar WiFi connectivity

### "GPS test failed"
1. Go to open area (no roof/walls)
2. Wait for clearer GPS signal
3. Ensure both phone and collar have GPS enabled
4. Try different location
5. Check if too far from collar (>50m)

---

**Last Updated:** 2025-12-28
**For Developers:** See ROADMAP.md for implementation details
**For Users:** This is the technical workflow - user-facing instructions will be simplified
