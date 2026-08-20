import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';
import 'quiz_model.dart';
import 'quiz_service.dart';

class QuizController extends ChangeNotifier {
  final int microtrainingId;
  final List<QuizQuestionModel> questions;
  final bool shuffleQuestions;

  QuizController({
    required this.microtrainingId,
    required this.questions,
    this.shuffleQuestions = false,
  }) {
    _displayQuestions = List.from(questions);
    if (shuffleQuestions && _displayQuestions.length > 1) {
      _displayQuestions.shuffle(Random());
    }
  }

  late final List<QuizQuestionModel> _displayQuestions;
  final Map<int, dynamic> _selectedAnswers = {};
  bool _isSubmitting = false;
  final bool _isLoadingFreeze = false;
  bool _isCheckingFreeze = false;
  QuizFreezeStatus? _freezeStatus;
  QuizSubmitResponse? _result;
  String? _error;

  List<QuizQuestionModel> get displayQuestions => _displayQuestions;
  Map<int, dynamic> get selectedAnswers => _selectedAnswers;
  bool get isSubmitting => _isSubmitting;
  bool get isLoadingFreeze => _isLoadingFreeze;
  bool get isCheckingFreeze => _isCheckingFreeze;
  QuizFreezeStatus? get freezeStatus => _freezeStatus;
  QuizSubmitResponse? get result => _result;
  String? get error => _error;

  bool get allAnswered => _selectedAnswers.length == _displayQuestions.length;
  bool get isFrozen => _freezeStatus?.freezePeriodActive ?? false;

  dynamic getAnswerForQuestion(int questionId) => _selectedAnswers[questionId];

  void selectAnswer(int questionId, dynamic answer) {
    _selectedAnswers[questionId] = answer;
    notifyListeners();
  }

  Future<void> checkFreezeStatus() async {
    _isCheckingFreeze = true;
    _error = null;
    notifyListeners();

    try {
      final token = await StorageService.getAccessToken();
      _freezeStatus = await QuizService.checkFreezeStatus(
        accessToken: token ?? '',
        microtrainingId: microtrainingId,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isCheckingFreeze = false;
      notifyListeners();
    }
  }

  Future<void> submit() async {
    if (!allAnswered || _isSubmitting) return;

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final token = await StorageService.getAccessToken();
      final answers = _selectedAnswers.entries.map((e) {
        return QuizAnswerItem(questionId: e.key, answer: e.value);
      }).toList();

      _result = await QuizService.submitQuiz(
        accessToken: token ?? '',
        microtrainingId: microtrainingId,
        answers: answers,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void reset() {
    _selectedAnswers.clear();
    _result = null;
    _error = null;
    _isSubmitting = false;
    notifyListeners();
  }
}
