import 'package:upgrader/upgrader.dart';

class DutchUpgradeMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String message(UpgraderMessage messageKey) {
    if (languageCode == 'nl') {
      switch (messageKey) {
        case UpgraderMessage.body:
          return 'Er is een nieuwe versie van {{appName}} beschikbaar! De nieuwe versie is {{currentAppStoreVersion}}, u gebruikt nu versie {{currentInstalledVersion}}.';
        case UpgraderMessage.buttonTitleIgnore:
          return 'Negeer';
        case UpgraderMessage.buttonTitleLater:
          return 'Niet nu';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Kom maar door!';
        case UpgraderMessage.prompt:
          return 'Bent u in de gelegenheid om de nieuwe versie te downloaden?';
        case UpgraderMessage.releaseNotes:
          return 'Wat kunt u verwachten';
        case UpgraderMessage.title:
          return 'Een nieuwe update heeft u bereikt!';
      }
    }
    // Messages that are not provided above can still use the default values.

    return super.message(messageKey) ?? "Unknown message key";
  }
}
