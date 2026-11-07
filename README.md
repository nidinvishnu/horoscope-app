# Daily Horoscope

A Flutter app that shows a daily horoscope for your star sign and can remind you every day at a time you choose.

Built as a learning project to practise Flutter, local storage and scheduled notifications.

## Features

- Pick your star sign once, and the app remembers it
- A different reading each day, chosen by date and sign (works fully offline)
- Daily reminder notification at a time you pick, which still fires when the app is closed or the phone restarts
- Change the reminder time or turn it off at any time

## Tech

- Flutter and Dart
- `shared_preferences` for saving the sign and reminder time
- `flutter_local_notifications`, `timezone` and `flutter_timezone` for scheduled notifications

## Run it

1. Install Flutter and Android Studio, and start an Android emulator or plug in a phone
2. Clone the repo, then run:

```
cd horoscope_app
flutter pub get
flutter run
```

3. Run the tests with `flutter test`

## Limitations

- Tested on Android only. Building for iOS needs a Mac
- The readings come from a fixed list of 30 messages, not a live source
- Horoscopes are for entertainment only

## Possible next steps

- AI-generated daily readings
- Notification text that includes the day's reading
- Widgets and a nicer visual theme