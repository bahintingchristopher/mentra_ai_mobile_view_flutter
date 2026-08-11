import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/feeds/feed_post_card.dart';

class FeedView extends StatefulWidget {
  final Future feedFuture;
  final String accessToken;
  final String? sessionKey;
  final VoidCallback? onCommentAdded;

  const FeedView({
    super.key,
    required this.feedFuture,
    required this.accessToken,
    this.sessionKey,
    this.onCommentAdded,
  });

  @override
  State<FeedView> createState() => _FeedViewState();
}

// '-' in _FeedViewState is a naming convention in Dart to indicate that the class is private to the library. It means that this class can only be accessed within the file it is defined in, and not from other files. This is a common practice in Dart to encapsulate implementation details and prevent external access to certain classes or members.
class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.feedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                color: Color(0xFF38BDF8),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Error loading posts: ${snapshot.error}',
                style: const TextStyle(
                  color: Color(0xFFF87171),
                ),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'No posts available.',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                ),
              ),
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

            return FeedPostCard(
              post: post,
              accessToken: widget.accessToken,
              sessionKey: widget.sessionKey,
              onCommentAdded: widget.onCommentAdded,
            );
          },
        );
      },
    );
    
  }
}