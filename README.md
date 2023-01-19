# K.S.R.V. Njord App
[![Dart Code Metrics](https://github.com/ksrvnjord/app.main/actions/workflows/dartcodemetrics.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/dartcodemetrics.yml)
[![Flutter Analyze](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-analyze.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-analyze.yml)
[![Flutter Format](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-format.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/flutter-format.yml)
[![Codemagic build status](https://api.codemagic.io/apps/639df4a27b07a355e8861df9/639df4a27b07a355e8861df8/status_badge.svg)](https://codemagic.io/apps/639df4a27b07a355e8861df9/639df4a27b07a355e8861df8/latest_build)

De Flut-ter versie.

## How do I?

- Volg [`https://docs.flutter.dev/get-started/install`](https://docs.flutter.dev/get-started/install)
- Clone de repository
- Ga aan de slag in je eigen branch (`git checkout -b`)
- Download de dependencies: `flutter pub get`
- Start een emulator of sluit je telefoon aan
- Run de app: `flutter run`

## Architectuur
Via ["named routes" (Navigator)](https://api.flutter.dev/flutter/widgets/Navigator-class.html) kan je navigeren tussen de verschillende pages.

### Project Structuur
De folderstructuur is feature-based. Dit wil zeggen dat alle code die bij een feature hoort, in een aparte folder staat. Dit maakt het makkelijker om te navigeren in de code en om te weten waar je moet zijn om iets aan te passen. De code van features is dan verder opgedeeld in mappen die elk een bepaalde rol hebben. De structuur ziet er ongeveer zo uit:


- **lib**
    -  **src**
        - **features**
            - **announcements**
                - **api**
                - **models**
                - **pages**
                - **widgets**
            - **events**
                - ...
            - ...


Een feature heeft dus een map `api`, `models`, `pages` en `widgets`. De `api` map bevat de code die de app gebruikt om data op te halen van de server. De `models` map bevat de modellen die gebruikt worden om data op te halen en te versturen naar de server. De `pages` map bevat de code voor de verschillende pagina's die bij de feature horen. De `widgets` map bevat de code voor de widgets die op de verschillende pagina's gebruikt worden.

---
## Continuous Integration / Continuous Deployment
### Hoe breng ik een nieuwe versie uit in de App Store / Google Play Store?
Er worden automatisch builds gemaakt door Codemagic op basis van git tags.
De tags worden op hun beurt automatisch gegeneerd op basis van de versie in `pubspec.yaml` op de `main` branch met behulp van Github Actions.

 > Stel je hebt een branch met een nieuwe feature die je wilt uitbrengen. Je hebt de branch `feature/new-feature` en je hebt de versie in `pubspec.yaml` verhoogd naar `1.0.0+1`. Je maakt een pull request naar de `main` branch en wacht tot deze is goedgekeurd en gemerged. 
1. Zodra je branch is gemerged, wordt er automatisch een nieuwe git tag aangemaakt op basis van de versie in `pubspec.yaml`. De tag zal `1.0.0` zijn.
2. Codemagic zal dan een nieuwe build maken op basis van de tag. Deze build zal dan in de App Store / Google Play Store beschikbaar komen voor de interne testgroep.

### Code Quality & Style
Code quality wordt gecontroleerd door verschillende tools. Als er fouten zijn, zal de pull request falen en zal je de fouten moeten oplossen. Je kan de tools ook lokaal uitvoeren om fouten op te sporen.
Er zijn verschillende checks die worden uitgevoerd als onderdeel van de CI/CD pipeline. Deze checks worden uitgevoerd op elke push en pull request naar `main`.

#### Dart Code Linter
We gebruiken de Dart Code Linter om de code te analyseren op fouten en om de code te formatteren.
Je runt de linter lokaal met:
```bash
$ flutter analyze
```

#### Dart Code Metrics
We gebruiken de Dart Code Metrics om de code te analyseren op code smells.  
Je runt dart code metrics lokaal met:
```bash
$ flutter pub run dart_code_metrics:metrics analyze lib
```
Dit zal de `lib` folder analyseren.

#### Flutter Format
We gebruiken de Flutter Format om de code te formatteren. 
Je kunt de formatter lokaal uitvoeren met:
```bash
$ flutter format .
```
