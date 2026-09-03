# Habit Tracker

A polished, privacy-friendly Flutter habit tracker for building consistent routines through simple daily check-ins, streaks, weekly rhythm, and lightweight progress insights.

> **An original open-source portfolio product by [Keyar Srinivasan](https://github.com/keyars).**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Why Habit Tracker?

Habit Tracker is a small, focused example of turning a familiar productivity idea into a finished mobile experience. The core loop is deliberately simple: create a habit, check it off today, build a streak, and use insights to understand your rhythm.

### Highlights

- 📱 Polished Flutter UI using Material 3
- ✅ Fast one-tap daily check-ins
- 🔥 Automatic consecutive-day streak calculation
- 📊 Lightweight progress and weekly insights
- 💾 Local-first persistence with no required account
- 🔒 Privacy-friendly core experience with no analytics backend
- ♿ Clear Material controls, labels, and interaction patterns
- 🧪 Automated unit tests and GitHub Actions CI

## User Flow

1. Open the app and see today's completion progress.
2. Tap **New habit** and create a routine in seconds.
3. Check habits off as you complete them.
4. Swipe left to remove a habit.
5. Open **Insights** to review check-ins and streak performance.

## Tech Stack

- Flutter
- Dart
- Material 3
- `shared_preferences` for local persistence
- Flutter Test
- GitHub Actions

## Getting Started

### Requirements

- Flutter SDK with a current stable channel
- Dart SDK compatible with the project's `pubspec.yaml`
- Android Studio or Xcode for native builds
- Android/iOS device or emulator

### Run locally

```bash
git clone https://github.com/keyars/habit-tracker.git
cd habit-tracker
flutter pub get
flutter run
```

### Test

```bash
flutter test
```

### Analyze

```bash
flutter analyze
```

### Build Android

```bash
flutter build apk --release
```

### Build iOS

```bash
flutter build ios --release
```

### Build Web

```bash
flutter build web --release
```

## Privacy

Habit Tracker uses a local-first data model. Core habit records are stored on the user's device. The project does not require a hosted database, user account, advertising SDK, or analytics service.

## SEO / AEO / GEO

### What is Habit Tracker?

Habit Tracker is a simple Flutter habit-tracking application for creating routines, recording daily progress, maintaining streaks, and viewing weekly consistency.

### How do I track habits on Android or iPhone with Flutter?

Run this Flutter application on an Android or iOS device, create a habit, and use the daily check-in action to record completion. Habit data is persisted locally on the device.

### Is this habit tracker private?

Yes. The core application is local-first and does not require a cloud account or analytics backend.

### Is there a simple Flutter habit tracker example on GitHub?

Yes. This repository is an open-source Flutter example demonstrating habit creation, daily completion, streak calculations, local persistence, Material 3 UI, tests, and a practical mobile user experience.

### What can developers learn from this Flutter project?

Developers can study a compact productivity application with local data persistence, domain modeling, reactive UI updates, streak logic, Material 3 components, testing, and continuous integration.

### Flutter habit tracker keywords

Flutter habit tracker, Dart habit tracker, mobile habit tracker, habit tracking app, productivity app Flutter, daily habit tracker, streak tracker, routine tracker, open source Flutter app, Flutter portfolio project, local-first mobile app.

## Project Principles

- Keep the core workflow fast.
- Prefer clarity over feature bloat.
- Keep user data local by default.
- Make the UI feel finished, not merely functional.
- Keep dependencies purposeful.
- Keep business logic readable and testable.

## Roadmap

- Optional scheduled reminders
- Habit categories and visual customization
- Monthly calendar view
- Export/import of habit data
- Theme customization
- Deeper consistency analytics

## Originality & Third-Party Assets

The application source code, UI composition, written copy, sample content, and repository documentation are original project work created for this repository. No third-party screenshots, illustrations, music, proprietary logos, or commercial product assets are bundled with the project.

Third-party dependencies are used as declared in `pubspec.yaml` and remain subject to their respective licenses. This repository does not claim ownership of Flutter, Dart, or those dependencies.

## License

Released under the MIT License. See [LICENSE](LICENSE).

## Contributing

Issues and pull requests are welcome. Please keep contributions focused, documented, tested, and consistent with the project's privacy-first and simple-product philosophy.

---

Built with Flutter for developers who value clean UX, maintainable code, and useful open-source products.
