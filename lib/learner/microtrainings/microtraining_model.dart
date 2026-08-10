class MicrotrainingModel {
  final List<String> categories;
  final String title;
  final String status;
  final String pendingStatusText;
  final String? description;
  final int questionsCount;
  final String assignedDate;
  final String noticeMessage;

  MicrotrainingModel({
    required this.categories,
    required this.title,
    required this.status,
    required this.pendingStatusText,
    this.description,
    required this.questionsCount,
    required this.assignedDate,
    required this.noticeMessage,
  });

  factory MicrotrainingModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedCategories = [];

    // 1. Extract categories list or single category string
    if (json['categories'] != null && json['categories'] is List) {
      parsedCategories = (json['categories'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['category'] != null) {
      parsedCategories = [json['category'].toString()];
    }

    // 2. Ensure "Microtraining" badge is present
    bool hasMicro = parsedCategories.any((cat) => cat.toLowerCase().contains('microtraining'));
    if (!hasMicro) {
      parsedCategories.insert(0, 'Microtraining');
    }

    // 3. Extract question count cleanly (handles both List.length and integer count)
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

    return MicrotrainingModel(
      categories: parsedCategories,
      title: json['title'] ?? '',
      status: json['status'] ?? 'Pending',
      pendingStatusText: json['pending_status_text'] ?? 'Pending completion',
      description: json['description'],
      questionsCount: calculatedQuestionsCount,
      assignedDate: json['assigned_date'] ?? json['created_at'] ?? '',
      noticeMessage: json['notice_message'] ?? '',
    );
  }
}
