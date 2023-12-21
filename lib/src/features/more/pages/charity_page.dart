import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_agenda.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/lustrum_background_widget.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_progress_indicator.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_text.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_title.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/njord_year.dart';
import 'package:ksrvnjord_main_app/src/features/profiles/api/user_provider.dart';

class CharityPage extends ConsumerWidget {
  const CharityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const pageOffset = 0.0;
    const sizedBoxHeight = 16.0;
    final currentUserVal = ref.watch(currentUserProvider);

    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('charity')
          .doc('leontienhuis')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        Map<String, dynamic>? charityData =
            snapshot.data?.data() as Map<String, dynamic>?;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/leontienhuis.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Lustrumgoededoel',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Image.asset(
                  'images/leontienhuis-mirrored.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          body: CustomPaint(
            painter: LustrumBackgroundWidget(
              pageOffset: pageOffset,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CharitySectionText(
                      text:
                          'Als goededoelencommissie willen wij graag een extra'
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
                    CharityProgressIndicator(charityData: charityData),
                    const SizedBox(height: sizedBoxHeight),
                    const CharitySectionText(
                      text:
                          'Wil je zelf een bijdrage leveren aan het Leontienhuis?'
                          ' Doneer dan via onderstaande link!',
                      fontSize: 16,
                    ),
                    Center(
                      child: InkWell(
                        child: const Text(
                          'Doneer!',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          final url = Uri.parse(
                              'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=E-Sbs4ZuQHibS8OxtPLRiQ');
                          launchUrl(url);
                        },
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: sizedBoxHeight),
                    const CharitySectionTitle(
                      text: 'Agenda',
                      fontSize: 18,
                    ),
                    const CharityAgenda(),
                    const Divider(),
                    const SizedBox(height: sizedBoxHeight),
                    const CharitySectionTitle(
                      text: 'Meer weten?',
                      fontSize: 18,
                    ),
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
                        onTap: () {
                          final url = Uri.parse('https://www.leontienhuis.nl/');
                          launchUrl(url);
                        },
                      ),
                    ),
                    Image.asset(
                      'images/leontienhuis.png',
                      width: 300,
                      height: 200,
                    ),
                  ],
                ),
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
                      foregroundColor: colorScheme.onTertiaryContainer,
                      backgroundColor: colorScheme.tertiaryContainer,
                      onPressed: () => context.goNamed('CharityEdit'),
                      icon: const Icon(Icons.edit),
                      label: const Text('Pas bedragen aan'),
                    )
                  : null;
            },
            loading: () => const SizedBox.shrink(),
            error: (e, s) {
              FirebaseCrashlytics.instance.recordError(e, s);

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
