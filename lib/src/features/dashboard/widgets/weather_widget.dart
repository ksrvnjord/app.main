// ignore_for_file: no-magic-number

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/weather_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/weather_metric_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({
    super.key,
  });

  int windspeedToBeaufort(final double windspeed) {
    // Windspeed is in km/h.
    if (windspeed < 1) {
      return 0;
    } else if (windspeed < 6) {
      return 1;
    } else if (windspeed < 12) {
      return 2;
    } else if (windspeed < 20) {
      return 3;
    } else if (windspeed < 29) {
      return 4;
    } else if (windspeed < 39) {
      return 5;
    } else if (windspeed < 50) {
      return 6;
    } else if (windspeed < 62) {
      return 7;
    } else if (windspeed < 75) {
      return 8;
    } else if (windspeed < 89) {
      return 9;
    } else if (windspeed < 103) {
      return 10;
    } else if (windspeed < 118) {
      return 11;
    } else {
      return 12;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider);

    return weather.when(
      data: (data) {
        final currentWeather = data['current_weather'];
        final int currentTemperature =
            (currentWeather['temperature'] as double).floor();
        final windspeed = currentWeather['windspeed'] as double;
        final sunrise = DateTime.parse(data['daily']['sunrise'][0]);
        final sunset = DateTime.parse(data['daily']['sunset'][0]);
        final winddirection = (currentWeather['winddirection'] + 180) %
            360; // Winddirection should indicate where the wind is going to.

        final fetchTime = DateTime.parse(currentWeather['time']);
        // Determine if it is night or day based on sunrise and sunset.
        final now = DateTime.now();
        final bool sunsetIsFirst = now.isBefore(sunset) && now.isAfter(sunrise);

        final uvIndex = data['hourly']['uv_index'][now.hour];

        final String windspeedCss =
            "wi-wind-beaufort-${windspeedToBeaufort(windspeed)}";

        return [
          const Text("K.S.R.V. Njord").fontSize(16).fontWeight(FontWeight.bold),
          // ignore: avoid-non-ascii-symbols
          Text("${currentTemperature.toString()}°").fontSize(32),
          [Icon(Icons.sunny), Text(uvIndex.toString()).fontSize(28)]
              .toRow(mainAxisAlignment: MainAxisAlignment.center),
          Wrap(children: [
            WeatherMetricWidget(
              icon: WeatherIcons.strong_wind,
              title: "Wind",
              mainText: "$windspeed km/u",
              main: [
                BoxedIcon(
                  WeatherIcons.fromString(
                    windspeedCss,
                    fallback: WeatherIcons.na,
                  ),
                  size: 32,
                ),
                WindIcon(
                  degree: winddirection,
                  size: 32,
                ),
              ].toRow(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              ),
            ),
            WeatherMetricWidget(
              icon: sunsetIsFirst ? WeatherIcons.sunset : WeatherIcons.sunrise,
              title: sunsetIsFirst ? "Zonsondergang" : "Zonsopgang",
              mainText:
                  DateFormat('HH:mm').format(sunsetIsFirst ? sunset : sunrise),
              bottomText:
                  "${sunsetIsFirst ? "Zonsopgang" : "Zonsondergang"}: ${DateFormat('HH:mm').format(sunsetIsFirst ? sunrise : sunset)}",
            ),
          ]),

          Text(
            "Laatste update om ${DateFormat(
              'HH:mm',
            ).format(fetchTime)}",
            style: Theme.of(context).textTheme.labelMedium,
          ).alignment(Alignment.centerRight),
        ].toColumn().padding(all: 8).card(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.6),
              elevation: 1,
            );
      },
      error: (err, stk) => Text(err.toString()),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}
