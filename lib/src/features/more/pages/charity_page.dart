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
            const Text('De Dirk Kuyt Foundation'),
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
                    ' Dit jaar heeft de goededoelencommissie de Dirk Kuyt Foundation gekozen om te steunen.'
                    ' De Dirk Kuyt Foundation is in 2005 opgericht door Dirk'
                    ' Kuyt met als doel om mensen met een verstandelijke of'
                    ' lichamelijke beperking net zoveel plezier aan sport te'
                    ' laten beleven als hij zelf altijd heeft ervaren.'
                    ' Zowel fysiek als mentaal en sociaal draagt sport immers'
                    ' bij aan het welzijn van mensen. De Dirk Kuyt Foundation'
                    ' neemt drempels (zowel letterlijk als figuurlijk) weg voor'
                    ' mensen met een beperking, zodat zij de kans hebben hun'
                    ' invulling te geven aan sporten. Sporten voor prestaties,'
                    ' meedoen met sport- of bewegingsactiviteiten of gewoon'
                    ' sportplezier beleven. Niet alleen vanwege de fysieke'
                    ' uitdaging, maar ook vanwege het sociale aspect. Er mag geen'
                    ' belemmering zijn om te kunnen sporten. Dirk Kuyt: "Als ik'
                    ' mensen met een beperking zie genieten van hun sport en het'
                    ' enthousiasme waarmee ze dat doen, dan geniet ik ook en ben'
                    ' ik trots dat we dit mede mogelijk hebben gemaakt!”',
                fontSize: 16,
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const CharitySectionText(
                text:
                    'Wil je zelf een bijdrage leveren aan de Dirk Kuyt Foundation?'
                    ' Doneer dan via onderstaande link!',
                fontSize: 16,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final url = Uri.parse(
                      'https://betaalverzoek.rabobank.nl/betaalverzoek/?id=bfWgihlRS8idnGsHDr7gWw',
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
                text: 'Check de website van de Dirk Kuyt Foundation:',
                fontSize: 16,
              ),
              
              Center(
                child: InkWell(
                  child: const Text(
                    'https://dirkkuytfoundation.nl/',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  // ignore: prefer-extracting-callbacks
                  onTap: () {
                    final url = Uri.parse('https://dirkkuytfoundation.nl/');
                    unawaited(launchUrl(url));
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: sizedBoxHeight),
              const Text(
                '"Iedere stap die we samen zetten, maakt een wereld van verschil!" - Dirk Kuyt',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/dirk_kuyt_foundation.png',
                width: imageWidth,
                height: imageHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
