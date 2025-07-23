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
# 📋 Offline QR Staff Timer – Flutter App

This is a fully offline Flutter app designed for small shops, clinics, or offices to log **staff attendance** using QR codes — no backend, no internet required.

---

## ✨ Features

- 📷 Scan staff QR code to Check-in or Check-out
- 🧑 Add / remove staff locally
- 🧾 View daily logs (date-wise)
- 🧪 Smart Check-in/Check-out detection
- 🔒 Works completely offline
- 📤 Optional CSV export (coming soon!)

---

## 📱 App Screens

1. **Scan QR**
   - Tap button → open camera → scan staff QR
   - Logs time and toggles between Check-in / Check-out

2. **Logs**
   - View logs grouped by date
   - Each entry shows: `Name - Action - Time`

3. **Staff**
   - Add/remove staff
   - Tap to generate printable QR code for each staff ID

---

## 🛠️ Getting Started

### ✅ 1. Clone the Repo

```bash
git clone <your-repo-url>
cd qr_staff
✅ 2. Install Dependencies
bash
Copy
Edit
flutter pub get
✅ 3. Run the App
bash
Copy
Edit
flutter run
Make sure your device or emulator is connected. Check with:

bash
Copy
Edit
flutter devices
📦 Required Flutter Packages
These are already included in pubspec.yaml, but for reference:

Package	Purpose
qr_flutter	Generate QR codes for staff
mobile_scanner	Scan QR codes with camera
path_provider	Save logs to local filesystem
shared_preferences	Store staff data locally
intl	Format time and dates
csv (optional)	For future CSV export

⚠️ Common Issues & Fixes
❌ rawValue is not defined for 'BarcodeCapture'
Problem: mobile_scanner updated its API.

Fix: Use the new BarcodeCapture format:

dart
Copy
Edit
onDetect: (BarcodeCapture capture) {
  final String? code = capture.barcodes.firstOrNull?.rawValue;
  ...
}
❌ Android NDK Version Error
Error:

cpp
Copy
Edit
mobile_scanner requires Android NDK 27.0.12077973
Fix:

Open android/app/build.gradle.kts

Replace:

kotlin
Copy
Edit
ndkVersion = flutter.ndkVersion
…with:

kotlin
Copy
Edit
ndkVersion = "27.0.12077973"
Then run:

bash
Copy
Edit
flutter clean
flutter pub get
flutter run
🧪 Example Use Case
Add a staff member named john_doe

Tap their QR code to print or save

Open “Scan QR” → scan their badge

✅ Their check-in is logged

Scan again later → ✅ logs check-out

📂 File Structure
css
Copy
Edit
lib/
├── main.dart
├── pages/
│   ├── scanner_page.dart
│   ├── logs_page.dart
│   └── staff_page.dart
├── utils/
│   ├── file_helper.dart
│   └── log_model.dart
🔜 Coming Soon (Optional Features)
🔐 PIN lock for Logs page

📤 Export logs to CSV

📅 Filter logs by date range

📃 License
This project is free to use and modify for personal and commercial use. No warranty is provided.