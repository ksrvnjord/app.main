import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_agenda.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_progress_indicator.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_text.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_title.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class CharityPage extends ConsumerWidget {
  const CharityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const sizedBoxHeight = 16.0;
    final currentUserVal = ref.watch(currentUserProvider);

    final colorScheme = Theme.of(context).colorScheme;

    double imageWidth = 300;
    double imageHeight = 200;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Goede Doel (ntb)'),
            const SizedBox(width: 20),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CharitySectionText(
                text: 'Als goededoelencommissie willen wij graag een extra'
                    ' tintje geven aan het lustrumjaar. Daarom gaan wij ons'
                    ' in samenwerking met het Zwanencomite een heel jaar'
                    ' lang inzetten om, door middel van verschillende evenementen,'
                    ' zoveel mogelijk geld in te zamelen voor het herstelprogramma'
                    ' van het Leontienhuis. Naast dat wij geld voor hen gaan'
                    ' inzamelen, willen we op Njord het gesprek aangaan over'
                    ' gewicht en eten in relatie tot sport, om op die manier'
                    ' de taboe op eetproblemen te verminderen. Check onze'
                    ' activiteiten onderaan de pagina!',
                fontSize: 16,
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionTitle(
                text: 'Het herstelprogramma',
                fontSize: 24,
              ),
              const CharitySectionText(
                text:
                    ' Het herstelprogramma van 1 persoon kost 2500 euro per jaar.'
                    ' Van dit geld wordt van alles bekostigd. Denk hierbij aan:'
                    ' maaltijden, workshops, yoga en het creatief atelier, maar'
                    ' uiteraard ook de vaste kosten van het pand. Onderstaande'
                    ' teller geeft aan hoeveel geld er al is opgehaald voor het Leontienhuis.',
                fontSize: 16,
              ),
              const SizedBox(height: sizedBoxHeight),
              const CharityProgressIndicator(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionText(
                text: 'Wil je zelf een bijdrage leveren aan het Leontienhuis?'
                    ' Doneer dan via onderstaande link!',
                fontSize: 16,
              ),
              Center(
                child: InkWell(
                  child: const Text(
                    'Doneer!',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  // ignore: prefer-extracting-callbacks
                  onTap: () {
                    final url = Uri.parse(
                      'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=E-Sbs4ZuQHibS8OxtPLRiQ',
                    );
                    unawaited(launchUrl(url));
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionTitle(text: 'Agenda', fontSize: 18),
              const CharityAgenda(),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionTitle(text: 'Meer weten?', fontSize: 18),
              const CharitySectionText(
                text: 'Check de website van het Leontienhuis:',
                fontSize: 16,
              ),
              Center(
                child: InkWell(
                  child: const Text(
                    'https://www.leontienhuis.nl/',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  // ignore: prefer-extracting-callbacks
                  onTap: () {
                    final url = Uri.parse('https://www.leontienhuis.nl/');
                    unawaited(launchUrl(url));
                  },
                ),
              ),
              Image.asset(
                'assets/images/leontienhuis.png',
                width: imageWidth,
                height: imageHeight,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: currentUserVal.when(
        data: (currentUser) {
          bool isGoedeDoelenCommissieCurrentYear = false;
          final groups = currentUser.groups;
          for (final groupRelation in groups) {
            final year = groupRelation.group.year;
            final groupName = groupRelation.group.name;
            if (year == getNjordYear() &&
                groupName == "Goede Doelencommissie") {
              isGoedeDoelenCommissieCurrentYear = true;
            }
          }

          final canEditCharity =
              isGoedeDoelenCommissieCurrentYear || currentUser.isAdmin;

          return canEditCharity
              ? FloatingActionButton.extended(
                  tooltip: "Pas bedragen aan",
                  foregroundColor: colorScheme.onTertiaryContainer,
                  backgroundColor: colorScheme.tertiaryContainer,
                  heroTag: 'CharityEdit',
                  onPressed: () => context.goNamed('CharityEdit'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Pas bedragen aan'),
                )
              : null;
        },
        error: (e, s) {
          unawaited(FirebaseCrashlytics.instance.recordError(e, s));

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
      ),
    );
  }
}
