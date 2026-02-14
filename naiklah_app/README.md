# NaikLah 🚗💨

**NaikLah** is a modern, social-focused ride-sharing and multimodal transportation app designed with a focus on safety, sustainability, and community. Built with Flutter, it provides a seamless experience for riders and guardians alike.

## 🚀 Key Features

- **Multimodal Trip Logging**: Earn points for walking, cycling, or transit trips.
- **Guardian Tracking**: Real-time location sharing and "Safe Arrival" notifications for family and friends.
- **Panic/SOS System**: Instant haptic-feedback triggered SOS alerts with real-time guardian notification.
- **Mock Authentication**: Quick-login demo flow with mock user data and a functional "Forgot Password" mock simulation.
- **Gamified Rewards**: Earn points and track CO₂ savings for every sustainable trip.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (v3.10.8+)
- **State Management**: Native Flutter (`setState`, `StreamBuilder`)
- **Backend & Database**: [Firebase Firestore](https://firebase.google.com/docs/firestore)
- **Mapping**: [OpenStreetMap](https://www.openstreetmap.org/) via [flutter_map](https://pub.dev/packages/flutter_map)
- **Location Services**: [Geolocator](https://pub.dev/packages/geolocator)
- **Device Integration**:
  - `vibration` for haptic feedback
  - `camera` for potential ID/Verification flows

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (v3.10.8 or later)
- Android Studio / VS Code with Flutter extension
- An active Firebase project (requires `google-services.json` / `GoogleService-Info.plist`)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Shahridan04/NaikLah.git
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🛡 Safety First
NaikLah prioritizes user safety with a dedicated Guardian Tracking screen and integrated SOS features to ensure peace of mind during every journey.

