import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_card.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_model.dart';
import 'package:mentra_mobile_view/learner/microtrainings/quiz_screen/quiz_model.dart';
import 'package:mentra_mobile_view/learner/microtrainings/quiz_screen/quiz.controller.dart';

class MicrotrainingQuizScreen extends StatefulWidget {
  final MicrotrainingModel item;

  const MicrotrainingQuizScreen({
    super.key,
    required this.item,
  });

  @override
  State<MicrotrainingQuizScreen> createState() =>
      _MicrotrainingQuizScreenState();
}

class _MicrotrainingQuizScreenState extends State<MicrotrainingQuizScreen> {
  late final QuizController _controller;
  Timer? _freezeTimer;

  @override
  void initState() {
    super.initState();
    _controller = QuizController(
      microtrainingId: widget.item.id,
      questions: widget.item.questions,
      shuffleQuestions: widget.item.shuffleQuestions,
    );
    _controller.addListener(_onControllerUpdate);
    _controller.checkFreezeStatus();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});

    if (_controller.freezeStatus != null && _controller.isFrozen) {
      _startFreezeCountdown();
    }

    if (_controller.result != null && _freezeTimer != null) {
      _freezeTimer!.cancel();
      _freezeTimer = null;
    }
  }

  void _startFreezeCountdown() {
    _freezeTimer?.cancel();
    _freezeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final remaining = _controller.freezeStatus?.remainingSeconds;
      if (remaining != null && remaining > 0) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _freezeTimer?.cancel();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_controller.result != null) {
      return _buildResultView(isDark);
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 12),
                label: const Text('Back to Dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isDark ? Colors.white : const Color(0xFF334155),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.item.description != null &&
                        widget.item.description!.isNotEmpty) ...[
                      Text(
                        widget.item.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (widget.item.audioFileUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MicrotrainingAudioPlayer(
                          key: ValueKey('audio_${widget.item.id}'),
                          audioUrl: widget.item.audioFileUrl,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else if (widget.item.videoUrl.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MicrotrainingVideoPlayer(
                          key: ValueKey('video_${widget.item.id}'),
                          videoUrl: widget.item.videoUrl,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (_controller.isCheckingFreeze) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ] else if (_controller.isFrozen) ...[
                      _buildFreezeBanner(isDark),
                      const SizedBox(height: 16),
                    ],
                    if (!_controller.isFrozen) ...[
                      ...List.generate(
                          _controller.displayQuestions.length, (qIndex) {
                        final question =
                            _controller.displayQuestions[qIndex];
                        return _buildQuestionCard(
                          context,
                          questionNumber: qIndex + 1,
                          question: question,
                          selectedOptionIndex:
                              _controller.getAnswerForQuestion(question.id),
                          onOptionSelected: (optIndex) {
                            if (question.type == 'true_false') {
                              _controller.selectAnswer(
                                  question.id, optIndex == 0);
                            } else if (question.type == 'yes_no') {
                              _controller.selectAnswer(
                                  question.id,
                                  optIndex == 0 ? 'yes' : 'no');
                            } else {
                              _controller.selectAnswer(
                                  question.id,
                                  question.options![optIndex]);
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                      if (_controller.error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _controller.error!,
                            style: const TextStyle(
                                color: Color(0xFFDC2626), fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _controller.allAnswered &&
                                  !_controller.isSubmitting
                              ? () => _controller.submit()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0EA5E9),
                            disabledBackgroundColor:
                                const Color(0xFFCBD5E1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _controller.isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Submit Quiz',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreezeBanner(bool isDark) {
    final remaining = _controller.freezeStatus?.remainingSeconds ?? 0;
    final minutes = (remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (remaining % 60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF92400E) : const Color(0xFFF59E0B),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.timer_off_rounded,
            size: 36,
            color: isDark ? const Color(0xFFFCD34D) : const Color(0xFFD97706),
          ),
          const SizedBox(height: 8),
          Text(
            'Quiz Freeze Period Active',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You must wait after a failed attempt before retrying.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFF92400E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$minutes:$seconds',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFFCD34D) : const Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context, {
    required int questionNumber,
    required QuizQuestionModel question,
    required dynamic selectedOptionIndex,
    required ValueChanged<int> onOptionSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<String> displayOptions = question.options ?? [];
    if (question.type == 'true_false') {
      displayOptions = ['True', 'False'];
    } else if (question.type == 'yes_no') {
      displayOptions = ['Yes', 'No'];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $questionNumber',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            question.questionText,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(displayOptions.length, (optIndex) {
              final isSelected = selectedOptionIndex == optIndex ||
                  (question.type == 'true_false' &&
                      selectedOptionIndex == (optIndex == 0)) ||
                  (question.type == 'yes_no' &&
                      selectedOptionIndex ==
                          (optIndex == 0 ? 'yes' : 'no')) ||
                  (question.type != 'true_false' &&
                      question.type != 'yes_no' &&
                      selectedOptionIndex == displayOptions[optIndex]);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0EA5E9)
                        : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: InkWell(
                  onTap: () => onOptionSelected(optIndex),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0EA5E9)
                                  : (isDark
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF94A3B8)),
                              width: 2,
                            ),
                            color: isSelected
                                ? const Color(0xFF0EA5E9)
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  size: 12, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            displayOptions[optIndex],
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF334155),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(bool isDark) {
    final result = _controller.result!;
    final boolViewBg =
        result.passed ? const Color(0xFF052E16) : const Color(0xFF450A0A);
    final boolViewBorder =
        result.passed ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final boolViewIcon =
        result.passed ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final boolViewColor =
        result.passed ? const Color(0xFF4ADE80) : const Color(0xFFF87171);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 12),
                label: const Text('Back to Dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isDark ? Colors.white : const Color(0xFF334155),
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? boolViewBg : boolViewBg.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: boolViewBorder, width: 2),
                        ),
                        child: Icon(boolViewIcon, size: 48, color: boolViewColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        result.passed
                            ? 'Congratulations!'
                            : 'Not Quite There Yet',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        result.message ??
                            (result.passed
                                ? 'You passed the quiz!'
                                : 'Some answers were incorrect.'),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          '${result.score} / ${result.total}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color:
                                result.passed ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(result.results.length, (index) {
                      final r = result.results[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: r.isCorrect
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              r.isCorrect
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              size: 20,
                              color: r.isCorrect
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFFF87171),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Question ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  if (!r.isCorrect && r.correctAnswer != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        'Correct answer: ${r.correctAnswer}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (result.earnedBadges.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Earned Badges',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: result.earnedBadges.map((badge) {
                          return Chip(
                            avatar: const Icon(Icons.emoji_events_rounded,
                                size: 18, color: Color(0xFFFBBF24)),
                            label: Text(
                              badge['name'] ?? 'Badge',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (!result.passed && result.freezePeriodActive) ...[
                      const SizedBox(height: 20),
                      _buildFreezeBanner(isDark),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
