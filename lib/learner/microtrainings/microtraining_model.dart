class MicrotrainingModel {
  final int id;
  final List<String> categories;
  final String title;
  final String status;
  final String pendingStatusText;
  final String? description;
  final String videoUrl;
  final int questionsCount;
  final String assignedDate;
  final String noticeMessage;

  MicrotrainingModel({
    required this.id,
    required this.categories,
    required this.title,
    required this.status,
    required this.pendingStatusText,
    this.description,
    required this.videoUrl,
    required this.questionsCount,
    required this.assignedDate,
    required this.noticeMessage,
  });

  factory MicrotrainingModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedCategories = [];

    if (json['categories'] != null && json['categories'] is List) {
      parsedCategories = (json['categories'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['category'] != null) {
      parsedCategories = [json['category'].toString()];
    }

    bool hasMicro = parsedCategories.any((cat) => cat.toLowerCase().contains('microtraining'));
    if (!hasMicro) {
      parsedCategories.insert(0, 'Microtraining');
    }

    int calculatedQuestionsCount = 0;

    if (json['questions_count'] is int) {
      calculatedQuestionsCount = json['questions_count'];
    } else if (json['questions_count'] is String) {
      calculatedQuestionsCount = int.tryParse(json['questions_count']) ?? 0;
    } else if (json['questions'] is List) {
      calculatedQuestionsCount = (json['questions'] as List).length;
    } else if (json['questions'] is int) {
      calculatedQuestionsCount = json['questions'];
    } else if (json['questions'] is String) {
      calculatedQuestionsCount = int.tryParse(json['questions']) ?? 0;
    }

    int parsedId = 0;
    if (json['id'] is int) {
      parsedId = json['id'];
    } else if (json['id'] is String) {
      parsedId = int.tryParse(json['id']) ?? 0;
    }

    return MicrotrainingModel(
      id: parsedId,
      categories: parsedCategories,
      title: json['title'] ?? '',
      status: json['completion_status'] ?? json['status'] ?? 'Pending',
      pendingStatusText: json['pending_status_text'] ?? 'Pending completion',
      description: json['description'] ?? json['content'],
      videoUrl: json['video_url'] ?? '',
      questionsCount: calculatedQuestionsCount,
      assignedDate: json['assigned_date'] ?? json['created_at'] ?? '',
      noticeMessage: json['notice_message'] ?? '',
    );
  }
}
