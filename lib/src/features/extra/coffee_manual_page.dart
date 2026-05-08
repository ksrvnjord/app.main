import 'package:flutter/material.dart';

enum CoffeeOption {
  pan,
  koffiepot,
}

class CoffeeManualPage extends StatefulWidget {
  const CoffeeManualPage({super.key});

  @override
  State<CoffeeManualPage> createState() => _CoffeeManualPageState();
}

class _CoffeeManualPageState extends State<CoffeeManualPage> {
  CoffeeOption? selectedOption;

  final Map<CoffeeOption, List<String>> stepsPerOption = {
    CoffeeOption.pan: [
      "Haal de filterhouder door middel van de hendel uit de machine en gooi de eventueel gebruikte filter weg.",
      "Plaats een nieuwe filter in de houder, deze liggen vaak in de grote rode koffiepoederpot.",
      "Vul een plastic Heineken glas tot het groene logo en gooi prècies deze hoeveelheid koffiepoeder in de filter.",
      "Vul de pan tot de nok met water en giet de pan leeg boven de desbetreffende ingang bovenop het koffiezetapparaat.",
      "Zet de pan onder de filterhouder.",
      "Zet het koffieapparaat aan door middel van de knoppen aan de rechterkant van de machine."
    ],
    CoffeeOption.koffiepot: [
      "Haal de filterhouder door middel van de hendel uit de machine en gooi de eventueel gebruikte filter weg.",
      "Plaats een nieuwe filter in de houder, deze liggen vaak in de grote rode koffiepoederpot.",
      "Vul een plastic Heineken glas tot de kleine rode ster en gooi prècies deze hoeveelheid koffiepoeder in de filter.",
      "Vul de koffiepot tot de nok met water en giet de pot leeg boven de desbetreffende ingang bovenop het koffiezetapparaat.",
      "Zet de pot onder de filterhouder.",
      "Zet het koffieapparaat aan door middel van de knoppen aan de rechterkant van de machine."
    ]
  };

  final List<String> unwrittenRules = [
    "Loopt de machine nog? Wacht dan even met je beker er onder zetten, dit verpest de hele pot!",
    "Heb je de onderste koffie uit de kan gehaald? Zet meteen een nieuw bakkie!",
    "Zet je vroeg uit? Zet alvast een bakkie voor je coach!",
    "Ga je een bakkie halen? Vraag rond, er willen vast meer!",
    "Koffie op het vlonder gedronken? Neem je bekertje weer mee naar boven, dan hoeft er ook niet meer naar bekers gezocht te worden!",
    "Is de kan nog heet? Vul de kan dan nog niet met koud water!",
  ];

  @override
  Widget build(BuildContext context) {
    const double pagePadding = 16.0;
    const double fontSize = 22.0;
    const double pageSpacing = 12.0;

    final List<String> steps = stepsPerOption[selectedOption] ?? [];
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koffie Handleiding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(pagePadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welke koffiepot is nu beschikbaar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  )),
              const SizedBox(height: pageSpacing),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: pageSpacing,
                runSpacing: pageSpacing,
                children: [
                  _optionChip(
                    context: context,
                    label: 'Pan',
                    icon: Icons.soup_kitchen,
                    option: CoffeeOption.pan,
                  ),
                  _optionChip(
                    context: context,
                    label: 'Koffiepot',
                    icon: Icons.coffee_maker,
                    option: CoffeeOption.koffiepot,
                  ),
                ],
              ),
              const SizedBox(height: pageSpacing),
              if (selectedOption != null) ...[
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (index < steps.length) {
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(steps[index],
                              style: TextStyle(height: 1.35)),
                        );
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: ExpansionTile(
                          collapsedBackgroundColor:
                              colors.primaryContainer.withOpacity(0.75),
                          backgroundColor:
                              colors.primaryContainer.withOpacity(0.75),
                          leading: Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text(
                            "Belangrijk",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          shape: const Border(),
                          dense: true,
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          childrenPadding: const EdgeInsets.all(8.0),
                          children: [
                            ...List.generate(unwrittenRules.length, (idx) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${idx + 1}. '),
                                    Expanded(
                                      child: Text(unwrittenRules[idx]),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: pageSpacing),
                    itemCount: steps.length + 1,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required CoffeeOption option,
  }) {
    final bool isSelected = selectedOption == option;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: isSelected ? 1.04 : 1,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOutCubic,
      child: ChoiceChip(
        selected: isSelected,
        showCheckmark: false,
        selectedColor: colors.primaryContainer,
        backgroundColor: colors.surfaceContainerHighest,
        side: BorderSide(
          color: isSelected ? colors.primary : colors.outlineVariant,
          width: isSelected ? 1.4 : 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        label: SizedBox(
          width: 94,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 170),
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary.withOpacity(0.14)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: isSelected ? 36 : 33,
                  color:
                      isSelected ? colors.onPrimaryContainer : colors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                      letterSpacing: 0.2,
                    ),
              ),
            ],
          ),
        ),
        onSelected: (_) {
          setState(() {
            selectedOption = option;
          });
        },
      ),
    );
  }
}
