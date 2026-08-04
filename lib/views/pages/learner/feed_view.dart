import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/components/Learner/feed_post_card.dart';

class FeedView extends StatelessWidget {
  final Future<List<dynamic>> feedFuture;

  const FeedView({super.key, required this.feedFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: feedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error loading posts: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('No posts available.'),
            ),
          );
        }

        final posts = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];

            final firstName = post['first_name']?.toString().trim() ?? '';
            final lastName = post['last_name']?.toString().trim() ?? '';

            String authorName = '$firstName $lastName'.trim();
            if (authorName.isEmpty) {
              authorName = post['username'] ?? post['email'] ?? 'Anonymous';
            }

            final initialsList = authorName.split(' ').where((s) => s.isNotEmpty).toList();
            final initials = initialsList.isNotEmpty
                ? initialsList.map((s) => s[0]).take(2).join().toUpperCase()
                : 'A';

            String formattedTime = post['created_at'] ?? '';
            if (formattedTime.contains('T')) {
              try {
                final dt = DateTime.parse(formattedTime);
                formattedTime = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
              } catch (_) {}
            }

            return FeedPostCard(
              tag: post['category_name'] ?? post['tag'] ?? 'Company Post',
              authorName: authorName,
              authorInitial: initials,
              timestamp: formattedTime,
              content: post['content'] ?? post['message'] ?? post['text'] ?? '',
              commentCount: post['comments_count'] ?? post['comment_count'] ?? 0,
            );
          },
        );
      },
    );
  }
}