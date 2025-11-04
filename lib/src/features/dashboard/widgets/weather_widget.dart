import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ksrvnjord_main_app/src/features/dashboard/api/weather_provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:weather_icons/weather_icons.dart';
//weather icons source: https://erikflowers.github.io/weather-icons/

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

        final fetchTime = DateTime.parse(currentWeather['time']);
        final now = DateTime.now();
        final bool sunsetIsFirst = now.isBefore(sunset) && now.isAfter(sunrise);
        final maxUvIndex = (data['daily']['uv_index_max'][0] as num).round();

        final String windspeedCss =
            "wi-wind-beaufort-${windspeedToBeaufort(windspeed)}";

        determineKleding(final int temperature) {
          if (temperature < 9) {
            return KledingRecommendation.langlang;
          } else if (temperature < 18) {
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

        final hourlyWeather = data['hourly'];
        final List<String> times = List<String>.from(hourlyWeather['time']);
        final int currentIndex = times.indexWhere((time) {
          final parsedTime = DateTime.parse(time);
          return parsedTime.isAfter(now);
        });

        final List<Map<String, dynamic>> next48Hours =
            List.generate(48, (index) {
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

        // Build a concrete list of widgets so sunrise/sunset markers can be
        // placed relative to VoTijden (05:26 / 17:26).
        final List<Widget> hourItems = [];

        Widget clothingWidget = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                clothingImagePath!,
                width: 45,
                height: 100,
              ),
              Container(
                width: 1,
                height: 80,
                margin: const EdgeInsets.only(left: 8.0),
                color: Theme.of(context).dividerColor,
              ),
            ],
          ),
        );

        Widget buildSunMarker(DateTime sunTime, bool isSunrise) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm').format(sunTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 22),
                const SizedBox(height: 8),
                Icon(
                  isSunrise ? WeatherIcons.sunrise : WeatherIcons.sunset,
                  size: 24,
                ),
                const SizedBox(height: 22),
              ],
            ),
          );
        }

        Widget buildHourTile(Map<String, dynamic> hourData,
            {String? overrideDisplayTime}) {
          DateTime tileTime = hourData['time'];
          // VoTijden: special displayed minutes
          // If overrideDisplayTime is provided we respect it (used to force regular 17:00 when needed).
          String displayTime =
              overrideDisplayTime ?? DateFormat('HH:mm').format(tileTime);
          if (overrideDisplayTime == null &&
              tileTime.hour == 17 &&
              tileTime.minute == 0) {
            displayTime = '17:26';
          }

          final windspeedTile = (hourData['windspeed'] as num).toDouble();
          final windspeedCssTile =
              "wi-wind-beaufort-${windspeedToBeaufort(windspeedTile)}";

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayTime,
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
                Icon(
                  WeatherIcons.fromString(
                    windspeedCssTile,
                    fallback: WeatherIcons.na,
                  ),
                )
              ],
            ),
          );
        }

        // Collect all sunrise/sunset events that fall within the next48Hours span.
        final List<String> dailySunriseList =
            List<String>.from(data['daily']['sunrise']);
        final List<String> dailySunsetList =
            List<String>.from(data['daily']['sunset']);

        final DateTime hoursStart = next48Hours.isNotEmpty
            ? next48Hours.first['time'] as DateTime
            : now;
        final DateTime hoursEnd =
            hoursStart.add(Duration(hours: next48Hours.length));

        final List<Map<String, dynamic>> sunEvents = [];

        for (final s in dailySunriseList) {
          final dt = DateTime.parse(s);
          if (!dt.isBefore(hoursStart) && dt.isBefore(hoursEnd)) {
            sunEvents.add({'time': dt, 'isSunrise': true});
          }
        }
        for (final s in dailySunsetList) {
          final dt = DateTime.parse(s);
          if (!dt.isBefore(hoursStart) && dt.isBefore(hoursEnd)) {
            sunEvents.add({'time': dt, 'isSunrise': false});
          }
        }
        sunEvents.sort(
            (a, b) => (a['time'] as DateTime).compareTo(b['time'] as DateTime));

        // Start with the clothing image
        hourItems.add(clothingWidget);

        for (final hourData in next48Hours) {
          final DateTime tileTime = hourData['time'] as DateTime;
          final DateTime tileEnd = tileTime.add(const Duration(hours: 1));

          // Find any sun event that occurs within this hour tile.
          Map<String, dynamic>? ev;
          for (final e in sunEvents) {
            final DateTime evTime = e['time'] as DateTime;
            if (!evTime.isBefore(tileTime) && evTime.isBefore(tileEnd)) {
              ev = e;
              break;
            }
          }

          // Only treat 17:00 special (displayed as 17:26) for sunset placement.
          final bool is1726 = tileTime.hour == 17 && tileTime.minute == 0;

          if (ev != null) {
            final DateTime evTime = ev['time'] as DateTime;
            final bool isSunrise = ev['isSunrise'] as bool;

            // Special case: sunset exactly at 17:26 -> skip VoTijd display.
            if (!isSunrise &&
                is1726 &&
                evTime.hour == 17 &&
                evTime.minute == 26) {
              // Show regular 17:00 tile (override) then the sunset marker.
              hourItems.add(buildHourTile(hourData,
                  overrideDisplayTime: DateFormat('HH:mm').format(tileTime)));
              hourItems.add(buildSunMarker(evTime, false));
              continue;
            }

            if (!isSunrise && is1726) {
              // Sunset in the 17:00 hour: place before/after 17:26 depending on minute
              if (evTime.minute < 26) {
                hourItems.add(buildSunMarker(evTime, isSunrise));
                hourItems.add(buildHourTile(hourData));
              } else {
                hourItems.add(buildHourTile(hourData));
                hourItems.add(buildSunMarker(evTime, isSunrise));
              }
              continue;
            }

            // Normal placement for all other events (including sunrises)
            hourItems.add(buildSunMarker(evTime, isSunrise));
            hourItems.add(buildHourTile(hourData));
            continue;
          }

          // No sun marker in this hour, just add the tile
          hourItems.add(buildHourTile(hourData));
        }

        return [
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: hourItems,
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
