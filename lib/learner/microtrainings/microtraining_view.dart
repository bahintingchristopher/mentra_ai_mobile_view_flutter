import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_card.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_model.dart';

class MicrotrainingView extends StatelessWidget {
  final List<MicrotrainingModel> items;
  final bool loading;
  final String? error;
  final VoidCallback? onRetry;
  final void Function(int microtrainingId)? onVideoCompleted;
  final void Function(MicrotrainingModel item)? onOpenForum;
  final void Function(MicrotrainingModel item)? onStartQuiz;
  final int? scrollToMicrotrainingId;
  final GlobalKey? scrollKey;

  const MicrotrainingView({
    super.key,
    this.items = const [],
    this.loading = false,
    this.error,
    this.onRetry,
    this.onVideoCompleted,
    this.onOpenForum,
    this.onStartQuiz,
    this.scrollToMicrotrainingId,
    this.scrollKey,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Error loading microtrainings: $error',
                style: const TextStyle(color: Colors.red),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                TextButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text('No microtrainings found.'),
        ),
      );
    }

    if (scrollToMicrotrainingId != null && scrollKey != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollKey?.currentContext != null) {
          Scrollable.ensureVisible(
            scrollKey!.currentContext!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bool shouldAttachKey = scrollToMicrotrainingId != null &&
            scrollKey != null &&
            item.id == scrollToMicrotrainingId;

        return MicrotrainingCard(
          key: shouldAttachKey ? scrollKey : null,
          item: item,
          onVideoCompleted: onVideoCompleted != null
              ? () => onVideoCompleted!(item.id)
              : null,
          onOpenForum: onOpenForum != null ? () => onOpenForum!(item) : null,
          onStartQuiz: onStartQuiz != null ? () => onStartQuiz!(item) : null,
        );
      },
    );
  }
}
