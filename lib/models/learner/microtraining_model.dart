class MicrotrainingModel {
  final String id;
  final String title;
  final List<String> categories;
  final String status;
  final String pendingStatusText;
  final String? description;
  final int questionsCount;
  final String assignedDate;
  final String noticeMessage;
  final String? thumbnailUrl;

  MicrotrainingModel({
    required this.id,
    required this.title,
    required this.categories,
    required this.status,
    required this.pendingStatusText,
    this.description,
    required this.questionsCount,
    required this.assignedDate,
    required this.noticeMessage,
    this.thumbnailUrl,
  });

  factory MicrotrainingModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse category list safely
    List<String> parseCategories(dynamic categoriesJson) {
      if (categoriesJson is List) {
        return categoriesJson.map((e) => e.toString()).toList();
      } else if (categoriesJson is String && categoriesJson.isNotEmpty) {
        return [categoriesJson];
      }
      return ['General'];
    }

    return MicrotrainingModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? 'Untitled Training',
      categories: parseCategories(json['categories'] ?? json['category']),
      status: json['status'] ?? 'pending',
      pendingStatusText: json['pending_status_text'] ?? json['status_text'] ?? 'Pending',
      description: json['description'] as String?,
      questionsCount: json['questions_count'] ?? json['total_questions'] ?? 0,
      assignedDate: json['assigned_date'] ?? json['created_at'] ?? '',
      noticeMessage: json['notice_message'] ?? json['notice'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categories': categories,
      'status': status,
      'pending_status_text': pendingStatusText,
      'description': description,
      'questions_count': questionsCount,
      'assigned_date': assignedDate,
      'notice_message': noticeMessage,
      'thumbnail_url': thumbnailUrl,
    };
  }
}