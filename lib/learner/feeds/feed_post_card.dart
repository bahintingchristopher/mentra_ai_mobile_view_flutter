import 'package:flutter/material.dart';
import 'feed_model.dart';
import 'likebutton/likebutton_view.dart';
import 'comments/comment_view.dart';

class FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final String accessToken;
  final String? sessionKey;
  final VoidCallback? onCommentAdded;
 
  const FeedPostCard({
  super.key,
  required this.post,
  required this.accessToken,
  this.sessionKey,
  this.onCommentAdded,
});

  String _getDisplayName(dynamic user) {
    if (user == null) return 'Anonymous';

    // Handle Map / JSON
    if (user is Map) {
      final firstName = (user['first_name'] ?? user['firstName'] ?? '').toString().trim();
      final lastName = (user['last_name'] ?? user['lastName'] ?? '').toString().trim();
      final combined = '$firstName $lastName'.trim();
      if (combined.isNotEmpty) return combined;

      final fallback = (user['username'] ?? user['name'] ?? user['email'] ?? '').toString().trim();
      if (fallback.isNotEmpty) return fallback;
    }

    // Handle Object properties
    try {
      final firstName = (user.firstName ?? '').toString().trim();
      final lastName = (user.lastName ?? '').toString().trim();
      final combined = '$firstName $lastName'.trim();
      if (combined.isNotEmpty) return combined;
    } catch (_) {}

    try {
      if (user.name != null && user.name.toString().trim().isNotEmpty) {
        return user.name.toString().trim();
      }
    } catch (_) {}

    try {
      if (user.username != null && user.username.toString().trim().isNotEmpty) {
        return user.username.toString().trim();
      }
    } catch (_) {}

    return 'Anonymous';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty || name == 'Anonymous') return '?';
    if (parts.length == 1) return parts[0][0].toLowerCase();
    return '${parts[0][0]}${parts[1][0]}'.toLowerCase();
  }

  String _formatRelativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }
    if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
    final years = (diff.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final displayName = _getDisplayName(post.author);
    final initials = _getInitials(displayName);
    final timeAgo = _formatRelativeTime(post.createdAt);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag Badge ("Company Post")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              post.tag,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Author Avatar, Name & Timestamp
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Post Message Content (Ensures backend content text renders properly)
          if (post.content.isNotEmpty) ...[
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Image Attachment
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 12),
          ],

          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Bottom Action Row
          Row(
  children: [
    // Like / Reaction Button
    LikeView(
  postId: post.id,
  accessToken: accessToken,
  sessionKey: sessionKey,
),

    const SizedBox(width: 16),

    // Comment Button
    InkWell(
      onTap: () {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return CommentView(
        postId: post.id,
        accessToken: accessToken,
        sessionKey: sessionKey,
         onCommentAdded: () {
        onCommentAdded?.call();
      },
      );
    },
  );
},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 20,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
            ),
            if (post.commentsCount > 0) ...[
              const SizedBox(width: 8),
              Text(
                '${post.commentsCount}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    ),

    const Spacer(),

    // Like Count
    if (post.likesCount > 0)
      Row(
        children: [
          const Icon(
            Icons.thumb_up_rounded,
            size: 18,
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(width: 6),
          Text(
            '${post.likesCount}',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
  ],
),
        ],
      ),
    );
  }
}