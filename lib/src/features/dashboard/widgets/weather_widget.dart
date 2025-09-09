import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/weather_provider.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/widgets/weather_metric_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:weather_icons/weather_icons.dart';

enum KledingRecommendation {
  langlang,
  langkort,
  kortkort,
}

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({
    super.key,
  });

  int windspeedToBeaufort(final double windspeed) {
    if (windspeed < 1) {
      return 0;
    }
    if (windspeed < 6) {
      return 1;
    }
    if (windspeed < 12) {
      return 2;
    }
    if (windspeed < 20) {
      return 3;
    }
    if (windspeed < 29) {
      return 4;
    }
    if (windspeed < 39) {
      return 5;
    }
    if (windspeed < 50) {
      return 6;
    }
    if (windspeed < 62) {
      return 7;
    }
    if (windspeed < 75) {
      return 8;
    }
    if (windspeed < 89) {
      return 9;
    }
    if (windspeed < 103) {
      return 10;
    }
    if (windspeed < 118) {
      return 11;
    }
    return 12;
  }

  IconData weathercodetoweathertype(final int weathercode) {
    if (weathercode == 0) {
      return WeatherIcons.day_sunny;
    }
    if (weathercode == 1 || weathercode == 2) {
      return WeatherIcons.cloudy;
    }
    if (weathercode == 3) {
      return WeatherIcons.cloud;
    }
    if (weathercode == 45 || weathercode == 48) {
      return WeatherIcons.fog;
    }
    if (weathercode >= 51 && weathercode <= 57) {
      return WeatherIcons.showers;
    }
    if (weathercode >= 61 && weathercode <= 67) {
      return WeatherIcons.rain;
    }
    if (weathercode >= 71 && weathercode <= 77) {
      return WeatherIcons.snow;
    }
    if (weathercode >= 80 && weathercode <= 82) {
      return WeatherIcons.rain;
    }
    if (weathercode >= 95 && weathercode <= 99) {
      return WeatherIcons.thunderstorm;
    }

    return WeatherIcons.na;
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
        final winddirection = (currentWeather['winddirection'] + 180) % 360;

        final fetchTime = DateTime.parse(currentWeather['time']);
        final now = DateTime.now();
        final bool sunsetIsFirst = now.isBefore(sunset) && now.isAfter(sunrise);
        final uvIndex = (data['hourly']['uv_index'][now.hour] as num).round();

        final String windspeedCss =
            "wi-wind-beaufort-${windspeedToBeaufort(windspeed)}";

        determineKleding(final int temperature) {
          if (temperature < 8) {
            return KledingRecommendation.langlang;
          } else if (temperature < 15) {
            return KledingRecommendation.langkort;
          } else {
            return KledingRecommendation.kortkort;
          }
        }

        final clothingImagePath = {
          KledingRecommendation.langlang: 'assets/images/weather_lang_lang.png',
          KledingRecommendation.langkort: 'assets/images/weather_lang_kort.png',
          KledingRecommendation.kortkort: 'assets/images/weather_kort_kort.png',
        }[determineKleding(currentTemperature)];

        // Extract the next 5 hours of weather data
        final hourlyWeather = data['hourly'];
        final List<String> times = List<String>.from(hourlyWeather['time']);
        final int currentIndex = times.indexWhere((time) {
          final parsedTime = DateTime.parse(time);
          return parsedTime.isAfter(now);
        });

        final List<Map<String, dynamic>> next24Hours =
            List.generate(24, (index) {
          final adjustedIndex = currentIndex + index;
          if (adjustedIndex >= times.length) return null; // Handle edge cases
          final time = DateTime.parse(hourlyWeather['time'][adjustedIndex]);
          final temperature = hourlyWeather['temperature_2m'][adjustedIndex];
          final windspeed = hourlyWeather['windspeed_10m'][adjustedIndex];
          final weathercode = hourlyWeather['weather_code'][adjustedIndex];
          return {
            'time': time,
            'temperature': temperature,
            'windspeed': windspeed,
            'weathercode': weathercode,
          };
        }).whereType<Map<String, dynamic>>().toList();

        return [
          Column(
            children: [
              SizedBox(
                  width: 350,
                  child: [
                    [          Wrap(children: [
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
              title: "Zon", 
              main: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BoxedIcon(
                    sunsetIsFirst ? WeatherIcons.sunset : WeatherIcons.sunrise,
                    size: 32,
                  ),
                ],
              ),
              mainText:
                  "${sunsetIsFirst ? "Op" : "Onder"}: ${DateFormat('HH:mm').format(sunsetIsFirst ? sunrise : sunset)} \n${sunsetIsFirst ? "Onder" : "Zon op"}: ${DateFormat('HH:mm').format(sunsetIsFirst ? sunset : sunrise)}",
            ),
          ]),
                      Image.asset(
                        clothingImagePath!,
                        width: 45,
                        height: 100,
                      ),
                    ].toRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ].toColumn(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                  )),
            ],
          ),

          // Add a horizontal ListView for the 24-hour forecast, boxed like the other widgets
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: next24Hours.length,
                  itemBuilder: (context, index) {
                    final hourData = next24Hours[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(hourData['time']),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${(hourData['temperature'] as num).round()}°C",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            weathercodetoweathertype(hourData['weathercode']),
                            size: 24,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

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
