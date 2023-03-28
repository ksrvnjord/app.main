class PollAnswer {
  final String userId;
  final String answer;
  final DateTime answeredAt;

  const PollAnswer({
    required this.userId,
    required this.answer,
    required this.answeredAt,
  });

  // create fromJson method
  factory PollAnswer.fromJson(Map<String, dynamic> json) {
    return PollAnswer(
      userId: json['userId'],
      answer: json['answer'],
      answeredAt: DateTime.parse(json['answeredAt']),
    );
  }

  // create toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answer': answer,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
}
