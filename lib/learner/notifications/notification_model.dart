class NotificationModel {
  final int id;
  final String type;
  final bool isRead;
  final String createdAt;
  final String actorName;
  final String title;

  NotificationModel({
    required this.id,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actorName,
    required this.title,
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

    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      type: notificationType,
      isRead: json['is_read'] == true || json['read'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      actorName: actor,
      title: displayTitle,
    );
  }
}