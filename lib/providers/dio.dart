/// This file builds a dioProvider to be used throughout
/// the application (you can also just use a direct instance
/// of dio if you like)

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider((ref) => Dio());
