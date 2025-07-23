# qr_staff

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.




README.md
markdown
Copy
Edit
# 📋 QR Staff Timer – Offline Flutter App

A lightweight, **fully offline** Flutter app designed for small businesses, clinics, or offices to log **staff attendance** using QR codes. No backend, no internet — just scan and go!

---

## ✨ Features

- 📷 Scan staff QR codes to Check-in or Check-out
- 🧑 Add and remove staff locally
- 🔍 View daily logs grouped by date
- 🧪 Smart Check-in/Check-out detection (no duplicate scans)
- 🔒 Works completely offline (perfect for limited connectivity)
- 📤 CSV export planned (coming soon!)

---

## 🖥️ Screens & Workflow

### 1. **Staff Setup**
- Add staff by ID using the text field
- Tap on any staff card to generate their printable QR code
- Remove staff directly from the list

### 2. **Scan QR**
- Tap “Scan QR” to open the camera
- Scan a staff QR → logs Check-in or Check-out automatically
- Instant confirmation via snackbar and on-screen message

### 3. **View Logs**
- Select a date to filter logs
- Displays entries with `Name - Action - Time`
- Smart grouping ensures clarity

---

## 🛠️ Installation

### 1. Clone this repo
```bash
git clone <your-repo-url>
cd qr_staff
2. Install dependencies
bash
flutter pub get
3. Run the app
bash
flutter run
✅ Make sure your device/emulator is listed:

bash
flutter devices
📦 Required Packages
Package	Purpose
qr_flutter	Generate QR codes
mobile_scanner	Scan QR codes via camera
path_provider	Read/write local logs file
intl	Format time and dates
csv (planned)	Export logs to spreadsheet
🚧 Common Errors
❌ rawValue not defined for BarcodeCapture
Fix: Use the new API:

dart
final code = capture.barcodes.firstOrNull?.rawValue;
❌ Android NDK version mismatch
Fix: In android/app/build.gradle.kts, set:

kotlin
ndkVersion = "27.0.12077973"
Then run:

bash
flutter clean
flutter pub get
flutter run
🧪 Example Use Case
Add staff ID: john_doe

Print or save QR code

Scan badge → ✅ Logs check-in

Scan again later → ✅ Logs check-out

📂 File Structure
lib/
├── main.dart
├── pages/
│   ├── scanner_page.dart     # QR scanning logic
│   ├── logs_page.dart        # View logs by date
│   └── staff_page.dart       # Add/remove staff, QR generation
├── utils/
│   ├── file_helper.dart      # Read/write logs to local file
│   └── log_model.dart        # Log entry model class
🔮 Coming Soon
🔐 PIN lock for Logs page

📤 Export logs to CSV

📅 Filter logs by date range

📃 License
Open source and free for personal or commercial use. No warranty or liability implied — use at your own discretion.

Made with ❤️ in Flutter. Happy scanning!


---

Let me know if you'd like a visual badge layout, installation GIFs, or a contr