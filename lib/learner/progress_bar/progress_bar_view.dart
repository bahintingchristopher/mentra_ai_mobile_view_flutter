import 'package:flutter/material.dart';

import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';

import 'progress_bar_controller.dart';
import 'progress_bar_model.dart';

class ProgressBarView extends StatefulWidget {
  final String accessToken;

  const ProgressBarView({
    super.key,
    this.accessToken = '',
  });

  @override
  State<ProgressBarView> createState() => _ProgressBarViewState();
}

class _ProgressBarViewState extends State<ProgressBarView> {
  final ProgressBarController _controller = ProgressBarController();

  late Future<ProgressBarModel> _progressFuture;

  @override
  void initState() {
    super.initState();

    _progressFuture = _loadProgress();
  }

  Future<ProgressBarModel> _loadProgress() async {
    final token = widget.accessToken.isNotEmpty
        ? widget.accessToken
        : (await StorageService.getAccessToken() ?? '');

    return _controller.fetchProgress(accessToken: token);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<ProgressBarModel>(
      future: _progressFuture,
      builder: (context, snapshot) {
        final progress = snapshot.data;
        final isLoading =
            snapshot.connectionState == ConnectionState.waiting;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YOUR PROGRESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0284C7),
                ),
              ),

              const SizedBox(height: 18),

              _progressRow(
                context: context,
                label: 'Streak',
                subtitle: 'days in a row',
                value: progress?.streak.toString(),
                color: theme.colorScheme.onSurface,
                isLoading: isLoading,
              ),

              const Divider(height: 24),

              _progressRow(
                context: context,
                label: 'XP',
                subtitle: 'points earned',
                value: progress?.xp.toString(),
                color: const Color(0xFF0EA5E9),
                isLoading: isLoading,
              ),

              const Divider(height: 24),

              _progressRow(
                context: context,
                label: 'Queued',
                subtitle: 'trainings waiting',
                value: progress?.queued.toString(),
                color: const Color(0xFFD4A800),
                isLoading: isLoading,
              ),

              const Divider(height: 24),

              _progressRow(
                context: context,
                label: 'Completed',
                subtitle: 'trainings completed',
                value: progress?.completedCount.toString(),
                color: const Color(0xFF16A34A),
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _progressRow({
    required BuildContext context,
    required String label,
    required String subtitle,
    required Color color,
    required bool isLoading,
    String? value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
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
                      .withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          Text(
            value ?? '—',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
      ],
    );
  }
}