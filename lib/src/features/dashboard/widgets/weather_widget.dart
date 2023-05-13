import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

        return [
          // ignore: avoid-non-ascii-symbols
          Text("Temperatuur: ${currentTemperature.toString()}°")
              .textColor(Colors.white),
          Text("Windsnelheid: ${windspeed.toString()} Km/u")
              .textColor(Colors.white),
        ].toColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
        );
      },
      error: (err, stk) => Text(err.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
