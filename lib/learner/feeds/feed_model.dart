class FeedPost {
  final String id;
  final dynamic author;
  final String content;
  final DateTime createdAt;
  final int commentsCount;

  // Keep this if other parts of your app still use it
  final int likesCount;

  // NEW: all reaction counts
  final Map<String, int> reactionCounts;

  final String? imageUrl;
  final String tag;
  final String? userReaction;

  FeedPost({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.commentsCount,
    required this.likesCount,
    required this.reactionCounts,
    this.imageUrl,
    this.tag = 'Company Post',
    this.userReaction,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    // -------------------------
    // POST ID
    // -------------------------
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

    // -------------------------
    // AUTHOR
    // -------------------------
    final rawAuthor =
        json['author'] ??
        json['user'] ??
        json['created_by'] ??
        json;

    // -------------------------
    // DATE
    // -------------------------
    final dateStr =
        (json['created_at'] ??
                json['createdAt'] ??
                json['date'] ??
                '')
            .toString();

    final parsedDate =
        DateTime.tryParse(dateStr) ?? DateTime.now();

    // -------------------------
    // CONTENT
    // -------------------------
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
      if (json[key] != null &&
          json[key].toString().trim().isNotEmpty) {
        extractedContent = json[key].toString().trim();
        break;
      }
    }

    // -------------------------
    // COMMENTS COUNT
    // -------------------------
    final rawComments =
        json['comments_count'] ??
        json['comment_count'] ??
        json['comments'];

    int parsedComments = 0;

    if (rawComments is int) {
      parsedComments = rawComments;
    } else if (rawComments is List) {
      parsedComments = rawComments.length;
    } else if (rawComments != null) {
      parsedComments =
          int.tryParse(rawComments.toString()) ?? 0;
    }

    // -------------------------
    // REACTION COUNTS
    // -------------------------
    final rawReactions =
        json['reaction_counts'] ??
        json['reactions_count'] ??
        json['likes_count'];

    Map<String, int> parsedReactionCounts = {};

    if (rawReactions is Map) {
      rawReactions.forEach((key, value) {
        final count = int.tryParse(value.toString()) ?? 0;

        parsedReactionCounts[key.toString()] = count;
      });
    } else if (rawReactions is int) {
      // If backend only gives a total like count
      parsedReactionCounts['like'] = rawReactions;
    }

    // -------------------------
    // LIKE COUNT
    // -------------------------
    final parsedLikes =
        parsedReactionCounts['like'] ?? 0;

    // -------------------------
    // CURRENT USER REACTION
    // -------------------------
    final String? userReaction =
        json['user_reaction']?.toString();

    // -------------------------
    // RETURN
    // -------------------------
    return FeedPost(
      id: extractedId,
      author: rawAuthor,
      content: extractedContent,
      createdAt: parsedDate,
      commentsCount: parsedComments,

      // Existing compatibility
      likesCount: parsedLikes,

      // NEW
      reactionCounts: parsedReactionCounts,

      userReaction: userReaction,

      imageUrl:
          json['image'] ??
          json['image_url'] ??
          json['media'],

      tag:
          (json['tag'] ??
                  json['category_name'] ??
                  json['category'] ??
                  'Company Post')
              .toString(),
    );
  }

  // -------------------------
  // TOTAL REACTIONS
  // -------------------------
  int get totalReactions {
    return reactionCounts.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }
}