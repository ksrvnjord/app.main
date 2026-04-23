import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_text.dart';
import 'package:ksrvnjord_main_app/src/features/more/widgets/charity_section_title.dart';

class CharityPage extends ConsumerWidget {
  const CharityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const sizedBoxHeight = 16.0;

    double imageWidth = 300;
    double imageHeight = 200;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Stichting Anne-Bo'),
            const SizedBox(width: 30),
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
                text:
                    'Dit jaar heeft de goededoelencommissie Stichting Anne-Bo ' // Geen komma!
                    'gekozen om te steunen. Stichting Anne-Bo is opgericht om '
                    'ambitieuze jonge vrouwen de kans te geven om hoger onderwijs '
                    'te volgen, ook wanneer hun achtergrond of financiële '
                    'situatie dat niet vanzelfsprekend maakt. De stichting '
                    'gelooft dat talent en doorzettingsvermogen zwaarder wegen '
                    'dan afkomst of netwerk, en zet zich actief in om barrières '
                    'te doorbreken en gelijke kansen te creëren. '
                    '\n\n' // witruimte
                    'Studeren is immers meer dan het behalen van een diploma. '
                    'Het draagt bij aan zelfvertrouwen, persoonlijke groei, '
                    'sociale verbinding en economische zelfstandigheid. Daarom '
                    'biedt Stichting Anne-Bo niet alleen financiële ondersteuning, '
                    'maar ook persoonlijke begeleiding. Elke student wordt '
                    'gekoppeld aan een coach die helpt bij studiekeuzes, het '
                    'vinden van een stage en het opbouwen van een professioneel '
                    'netwerk. Op deze manier levert Stichting Anne-Bo een '
                    'waardevolle bijdrage aan talentontwikkeling en '
                    'maatschappelijke vooruitgang, iets wat tijdens het 11e '
                    'vrouwenlustrum zeker niet onopgemerkt mag blijven!',
                fontSize: 16,
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const Text(
                '"Door stichting anne-bo kan ik genieten van het student zijn en hoef ik me geen zorgen te maken of ik het uberhaupt wel kan betalen om student te zijn." - Abir',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/stichting_anne_bo_wit.jpeg',
                width: imageWidth,
                height: imageHeight,
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionText(
                text: 'Wil je zelf een bijdrage leveren aan stichting Anne-Bo?'
                    ' Doneer dan via de onderstaande link!',
                fontSize: 16,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final url = Uri.parse(
                      'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=dg9hGutxQB-e7zDE6ZcIow',
                    );
                    launchUrl(url);
                  },
                  child: const Text('Doneer!'),
                ),
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionTitle(text: 'Meer weten?', fontSize: 18),
              const CharitySectionText(
                text: 'Check de website van stichting Anne-Bo:',
                fontSize: 16,
              ),
              Center(
                child: InkWell(
                  child: const Text(
                    'stichtinganne-bo.nl',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  // ignore: prefer-extracting-callbacks
                  onTap: () {
                    final url = Uri.parse('https://stichtinganne-bo.nl/');
                    unawaited(launchUrl(url));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
