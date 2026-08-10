class CommentModel {
  final int id;
  final String content;
  final String authorName;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.authorName,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json['author'] ?? {};

    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      authorName: user is Map
          ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
          : 'Anonymous',
      createdAt: DateTime.tryParse(
            json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}