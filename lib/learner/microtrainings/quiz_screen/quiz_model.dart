class QuizQuestionModel {
  final int id;
  final String type;
  final String questionText;
  final dynamic options;
  final int order;

  QuizQuestionModel({
    required this.id,
    required this.type,
    required this.questionText,
    this.options,
    required this.order,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'multiple_choice',
      questionText: json['question_text'] ?? '',
      options: json['options'],
      order: json['order'] ?? 0,
    );
  }
}

class QuizAnswerItem {
  final int questionId;
  final dynamic answer;

  QuizAnswerItem({required this.questionId, required this.answer});

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'answer': answer,
      };
}

class QuizResultItem {
  final int questionId;
  final bool isCorrect;
  final dynamic correctAnswer;

  QuizResultItem({
    required this.questionId,
    required this.isCorrect,
    this.correctAnswer,
  });

  factory QuizResultItem.fromJson(Map<String, dynamic> json) {
    return QuizResultItem(
      questionId: json['question_id'] ?? 0,
      isCorrect: json['is_correct'] ?? false,
      correctAnswer: json['correct_answer'],
    );
  }
}

class QuizSubmitResponse {
  final bool passed;
  final int score;
  final int total;
  final List<QuizResultItem> results;
  final List<Map<String, dynamic>> earnedBadges;
  final bool freezePeriodActive;
  final String? freezePeriodEnd;
  final int? remainingSeconds;
  final int? freezePeriodMinutes;
  final String? message;

  QuizSubmitResponse({
    required this.passed,
    required this.score,
    required this.total,
    required this.results,
    required this.earnedBadges,
    required this.freezePeriodActive,
    this.freezePeriodEnd,
    this.remainingSeconds,
    this.freezePeriodMinutes,
    this.message,
  });

  factory QuizSubmitResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return QuizSubmitResponse(
      passed: data['passed'] ?? false,
      score: data['score'] ?? 0,
      total: data['total'] ?? 0,
      results: (data['results'] as List<dynamic>?)
              ?.map((e) => QuizResultItem.fromJson(e))
              .toList() ??
          [],
      earnedBadges: (data['earned_badges'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [],
      freezePeriodActive: data['freeze_period_active'] ?? false,
      freezePeriodEnd: data['freeze_period_end'],
      remainingSeconds: data['remaining_seconds'],
      freezePeriodMinutes: data['freeze_period_minutes'],
      message: json['message'],
    );
  }
}

class QuizFreezeStatus {
  final bool freezePeriodActive;
  final int? remainingSeconds;
  final String? freezePeriodEnd;
  final int? freezePeriodMinutes;

  QuizFreezeStatus({
    required this.freezePeriodActive,
    this.remainingSeconds,
    this.freezePeriodEnd,
    this.freezePeriodMinutes,
  });

  factory QuizFreezeStatus.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return QuizFreezeStatus(
      freezePeriodActive: data['freeze_period_active'] ?? false,
      remainingSeconds: data['remaining_seconds'],
      freezePeriodEnd: data['freeze_period_end'],
      freezePeriodMinutes: data['freeze_period_minutes'],
    );
  }
}
