# crash_detector

A new Flutter project built with a Clean Architecture outline, demonstrating on-device crash detection via simulated sensor data.

## Simulating a Crash
The core detection algorithm operates locally using edge-based rules:
1. **Impact Threshold (G-Force)**: Analyzes continuous acceleration for forces exceeding 3.5 Gs.
2. **Rotation Validation (Gyroscope)**: Verifies the impact is accompanied by violent rotation (> 2.0 rad/s) to distinguish crashes from phone drops.
3. **Context Filtering**: Suppresses alerts if speed drops below 15 km/h on urban roads to prevent false positives from emergency braking.

**To trigger this end-to-end detection pipeline:**
1. Navigate to the **Settings** tab in the app's bottom navigation bar.
2. Tap the red **"Simulate Crash Event"** button.
3. This injects synthetic data (simulating a 10G impact and rapid 5 rad/s rotation at 65 km/h on a highway) directly into the app's BLoC state management layer, bypassing the lack of physical device data on the emulator.

## How to Run
Ensure you have an emulator or physical device connected and run:
```bash
flutter run
```

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
