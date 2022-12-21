# K.S.R.V. Njord App
[![Dart Code Metrics](https://github.com/ksrvnjord/app.main/actions/workflows/dartcodemetrics.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/dartcodemetrics.yml)
[![Flutter Analyze](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-analyze.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-analyze.yml)
[![Flutter Format](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-format.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-format.yml)
[![Codemagic build status](https://api.codemagic.io/apps/639df4a27b07a355e8861df9/639df4a27b07a355e8861df8/status_badge.svg)](https://codemagic.io/apps/639df4a27b07a355e8861df9/639df4a27b07a355e8861df8/latest_build)

De Flut-ter versie.

## How do I?

- Volg [`https://docs.flutter.dev/get-started/install`](https://docs.flutter.dev/get-started/install)
- Clone de repository
- Pak de `develop` branch om met de laatste iteratie aan de slag te gaan: `git checkout develop`
- Ga aan de slag in je eigen branch (`git checkout -b`)
- Download de dependencies: `flutter pub get`
- Run de app: `flutter run`

## Architectuur

Op dit moment nog niet heel veel boeiends, maar de verschillende schermen
werken via ["named routes" (Navigator)](https://api.flutter.dev/flutter/widgets/Navigator-class.html).

State-management gaat niet via MobX worden voorlopig, tenzij iemand dit
op een nette manier neer weet te kalken. Voorlopige keus is op RiverPod 
en flutter_hooks gevallen.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
