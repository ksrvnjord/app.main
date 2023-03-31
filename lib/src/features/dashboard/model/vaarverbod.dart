class Vaarverbod {
  final bool status;
  final String message;

  Vaarverbod({
    required this.status,
    required this.message,
  });

  factory Vaarverbod.fromJson(Map<String, dynamic> json) {
    return Vaarverbod(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
