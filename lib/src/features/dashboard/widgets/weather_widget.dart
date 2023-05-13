import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/weather_provider.dart';
import 'package:styled_widget/styled_widget.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherProvider);

    return weather.when(
      data: (data) {
        final currentWeather = data['current_weather'];
        final int currentTemperature =
            (currentWeather['temperature'] as double).floor();
        final windspeed = (currentWeather['windspeed'] as double).floor();
        final sunrise = DateTime.parse(data['daily']['sunrise'][0]);
        final sunset = DateTime.parse(data['daily']['sunset'][0]);

        final fetchTime = DateTime.parse(currentWeather['time']);

        return [
          // ignore: avoid-non-ascii-symbols
          const Text("Het weer op de K.S.R.V. Njord")
              .textColor(Colors.white)
              .fontSize(16)
              .fontWeight(FontWeight.bold),
          Text("Temperatuur: ${currentTemperature.toString()}°")
              .textColor(Colors.white),
          Text("Windsnelheid: ${windspeed.toString()} Km/u")
              .textColor(Colors.white),
          Text("Zonsopgang: ${DateFormat('HH:mm').format(sunrise)}")
              .textColor(Colors.white),
          Text("Zonsondergang: ${DateFormat('HH:mm').format(sunset)}")
              .textColor(
            Colors.white,
          ),
          Text("Laatst opgehaald om ${DateFormat('HH:mm').format(fetchTime)}")
              .textColor(Colors.blueGrey)
              .fontSize(12)
              .alignment(Alignment.centerRight),
        ]
            .toColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(all: 8)
            .card(
              color: Colors.blue[300],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
      },
      error: (err, stk) => Text(err.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
