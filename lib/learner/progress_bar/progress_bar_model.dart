class ProgressBarModel {
  final int streak;
  final int xp;
  final int queued;
  final int completedCount;

  ProgressBarModel({
    required this.streak,
    required this.xp,
    required this.queued,
    required this.completedCount,
  });

  factory ProgressBarModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return ProgressBarModel(
      streak: data['streak'] ?? 0,
      xp: data['xp'] ?? 0,
      queued: data['queued'] ?? 0,
      completedCount: data['completed_count'] ?? 0,
    );
  }
}