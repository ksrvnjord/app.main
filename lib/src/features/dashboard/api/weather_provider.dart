import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: prefer-static-class
final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  const double latitude = 52.1585;
  const double longitude = 4.4729;

  const dailyParams = ['sunrise', 'sunset', 'uv_index_max'];
  const hourlyParams = [
    'temperature_2m',
    'windspeed_10m',
    'weather_code',
    'uv_index'
  ];

  final res = await Dio().get(
    'https://api.open-meteo.com/v1/forecast',
    queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'timezone': 'Europe/Amsterdam',
      'current_weather': true,
      'daily': dailyParams,
      'hourly': hourlyParams, // Add hourly parameters
      'forecast_days': 2,
    },
  );

  return res.data as Map<String, dynamic>;
});
