import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:open_meteo/src/api.dart';

// ignore: prefer-static-class
final weatherProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  const double latitude = 52.1585;
  const double longitude = 4.4729;

  const dailyParams = ['sunrise', 'sunset'];

  final res = await Dio().get(
    'https://api.open-meteo.com/v1/forecast',
    queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'timezone': 'Europe/Amsterdam',
      'current_weather': true,
      'daily': dailyParams,
      'forecast_days': 1,
    },
  );

  return res.data as Map<String, dynamic>;
});

final weatherProvider2 = FutureProvider<ApiResponse<WeatherApi>>((ref) async {
  const double latitude = 52.1585;
  const double longitude = 4.4729;

  const dailyParams = {WeatherDaily.sunrise, WeatherDaily.sunset};

  final weather = WeatherApi();
  final response = await weather.request(
    latitude: latitude,
    longitude: longitude,
    forecastDays: 1,
    daily: dailyParams,
  );

  return response;
});
