import 'package:flutter/material.dart';

import 'progress_bar_controller.dart';
import 'progress_bar_model.dart';

class ProgressBarView extends StatefulWidget {
  final String accessToken;

  const ProgressBarView({
    super.key,
    required this.accessToken,
  });

  @override
  State<ProgressBarView> createState() =>
      _ProgressBarViewState();
}

class _ProgressBarViewState
    extends State<ProgressBarView> {
  final ProgressBarController _controller =
      ProgressBarController();

  late Future<ProgressBarModel> _progressFuture;

  @override
  void initState() {
    super.initState();

    _progressFuture =
        _controller.fetchProgress(
      accessToken: widget.accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return FutureBuilder<ProgressBarModel>(
      future: _progressFuture,
      builder: (context, snapshot) {
        // ------------------------------------------------------
        // LOADING
        // ------------------------------------------------------

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          );
        }

        // ------------------------------------------------------
        // ERROR
        // ------------------------------------------------------

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              'Unable to load progress.',
              style: TextStyle(
                fontSize: 13,
                color:
                    theme.colorScheme.onSurface,
              ),
            ),
          );
        }

        // ------------------------------------------------------
        // NO DATA
        // ------------------------------------------------------

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final progress = snapshot.data!;

        // ------------------------------------------------------
        // PROGRESS CARD
        // ------------------------------------------------------

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset:
                    const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // TITLE
              // ------------------------------------------------

              const Text(
                'YOUR PROGRESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                  color: Color(0xFF0284C7),
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // STREAK
              // ------------------------------------------------

              _progressRow(
                context: context,
                label: 'Streak',
                value:
                    progress.streak.toString(),
                subtitle: 'days in a row',
                color:
                    theme.colorScheme.onSurface,
              ),

              const Divider(height: 24),

              // ------------------------------------------------
              // XP
              // ------------------------------------------------

              _progressRow(
                context: context,
                label: 'XP',
                value:
                    progress.xp.toString(),
                subtitle: 'points earned',
                color:
                    const Color(0xFF0EA5E9),
              ),

              const Divider(height: 24),

              // ------------------------------------------------
              // QUEUED
              // ------------------------------------------------

              _progressRow(
                context: context,
                label: 'Queued',
                value:
                    progress.queued.toString(),
                subtitle:
                    'trainings waiting',
                color:
                    const Color(0xFFD4A800),
              ),

              const Divider(height: 24),

              // ------------------------------------------------
              // COMPLETED
              // ------------------------------------------------

              _progressRow(
                context: context,
                label: 'Completed',
                value: progress
                    .completedCount
                    .toString(),
                subtitle:
                    'trainings completed',
                color:
                    const Color(0xFF16A34A),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // PROGRESS ROW
  // ------------------------------------------------------------

  Widget _progressRow({
    required BuildContext context,
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: theme
                      .colorScheme
                      .onSurface
                      .withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight:
                FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}