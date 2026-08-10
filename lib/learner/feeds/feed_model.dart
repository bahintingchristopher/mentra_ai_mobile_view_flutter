class FeedPost {
  final String id;
  final dynamic author;
  final String content;
  final DateTime createdAt;
  final int commentsCount;
  final int likesCount;
  final String? imageUrl;
  final String tag;

  FeedPost({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.commentsCount,
    required this.likesCount,
    this.imageUrl,
    this.tag = 'Company Post',
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    String extractedId = '';
    if (json['post'] is Map && json['post']['id'] != null) {
      extractedId = json['post']['id'].toString();
    } else if (json['post_id'] != null) {
      extractedId = json['post_id'].toString();
    } else if (json['target_id'] != null) {
      extractedId = json['target_id'].toString();
    } else {
      extractedId = (json['id'] ?? '').toString();
    }
    
    final rawAuthor = json['author'] ?? json['user'] ?? json['created_by'] ?? json;

    final dateStr = (json['created_at'] ?? json['createdAt'] ?? json['date'] ?? '').toString();
    final parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();

    // Scan all common API field names for the post message body
    String extractedContent = '';
    final contentKeys = [
      'content',
      'message',
      'text',
      'body',
      'description',
      'title',
      'post',
      'details',
      'caption',
      'post_content',
      'text_content',
    ];

    for (final key in contentKeys) {
      if (json[key] != null && json[key].toString().trim().isNotEmpty) {
        extractedContent = json[key].toString().trim();
        break;
      }
    }

    // Parse Comments Count
    final rawComments = json['comments_count'] ?? json['comment_count'] ?? json['comments'];
    int parsedComments = 0;
    if (rawComments is int) {
      parsedComments = rawComments;
    } else if (rawComments is List) {
      parsedComments = rawComments.length;
    } else if (rawComments != null) {
      parsedComments = int.tryParse(rawComments.toString()) ?? 0;
    }

    // Parse Likes/Reactions Count
    final rawReactions = json['reaction_counts'] ?? json['reactions_count'] ?? json['likes_count'];
    int parsedLikes = 0;
    if (rawReactions is Map) {
      parsedLikes = (rawReactions['like'] ?? rawReactions['likes'] ?? 0) as int;
    } else if (rawReactions is int) {
      parsedLikes = rawReactions;
    } else if (json['likes'] is List) {
      parsedLikes = (json['likes'] as List).length;
    }

    return FeedPost(
      id: (json['id'] ?? '').toString(),
      author: rawAuthor,
      content: extractedContent,
      createdAt: parsedDate,
      commentsCount: parsedComments,
      likesCount: parsedLikes,
      imageUrl: json['image'] ?? json['image_url'] ?? json['media'],
      tag: (json['tag'] ?? json['category_name'] ?? json['category'] ?? 'Company Post').toString(),
    );
  }
}