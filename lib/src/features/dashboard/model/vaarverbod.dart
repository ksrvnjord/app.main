import 'package:flutter/foundation.dart';

@immutable
class Vaarverbod {
  final bool status;
  final String message;

  // ignore: sort_constructors_first
  factory Vaarverbod.fromJson(Map<String, dynamic> json) {
    return Vaarverbod(
      status: json['status'],
      message: json['message'],
    );
  }

  // ignore: sort_constructors_first
  const Vaarverbod({
    required this.status,
    required this.message,
  });
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
