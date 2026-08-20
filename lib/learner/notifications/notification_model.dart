class NotificationModel {
  final int id;
  final String type;
  final bool isRead;
  final String createdAt;
  final String actorName;
  final String title;
  final int? postId;
  final int? microtrainingId;

  NotificationModel({
    required this.id,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actorName,
    required this.title,
    this.postId,
    this.microtrainingId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // 1. Safe Actor Extraction
    String actor = 'System';
    if (json['created_by'] is Map) {
      final Map<String, dynamic> createdBy = json['created_by'];
      final String firstName = createdBy['first_name']?.toString().trim() ?? '';
      final String lastName = createdBy['last_name']?.toString().trim() ?? '';
      final String username = createdBy['username']?.toString().trim() ?? 'System';

      final String fullName = '$firstName $lastName'.trim();
      actor = fullName.isNotEmpty ? fullName : username;
    } else if (json['created_by'] != null) {
      actor = json['created_by'].toString();
    }

    // 2. Safe Title Extraction matching Django response
    String displayTitle = 'New Notification';
    final String notificationType = json['type']?.toString() ?? '';

    if (json['post'] is Map && json['post']['title'] != null) {
      displayTitle = '$actor: ${json['post']['title']}';
    } else if (notificationType == 'post_created') {
      displayTitle = '$actor created a new post';
    } else if (json['microtraining'] is Map) {
      displayTitle = json['microtraining']['title'] ?? 'New Microtraining Assigned';
    } else if (json['title'] != null) {
      displayTitle = json['title'].toString();
    }

    // 3. Extract entity IDs for navigation
    int? extractedPostId;
    if (json['post'] is Map && json['post']['id'] != null) {
      extractedPostId = json['post']['id'] is int
          ? json['post']['id'] as int
          : int.tryParse(json['post']['id'].toString());
    }

    int? extractedMicrotrainingId;
    if (json['microtraining'] is Map && json['microtraining']['id'] != null) {
      extractedMicrotrainingId = json['microtraining']['id'] is int
          ? json['microtraining']['id'] as int
          : int.tryParse(json['microtraining']['id'].toString());
    }

    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      type: notificationType,
      isRead: json['is_read'] == true || json['read'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      actorName: actor,
      title: displayTitle,
      postId: extractedPostId,
      microtrainingId: extractedMicrotrainingId,
    );
  }
}
