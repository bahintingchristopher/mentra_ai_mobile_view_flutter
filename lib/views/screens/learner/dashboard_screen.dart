import 'package:flutter/material.dart';

// Import your navbar, bottom nav, and feed card component
import '../../../components/Learner/learner_topnavbar.dart';
import '../../../components/Learner/learner_bottomnav.dart';
import '../../../components/Learner/feed_post_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Example dynamic feed list coming from your backend API
  final List<Map<String, dynamic>> _backendPosts = [
    {
      'author_name': 'shairey john',
      'author_initial': 'sj',
      'timestamp': '1 week ago',
      'content': 'Test Delete on different log im',
      'comment_count': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const LearnerTopNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feed list rendering dynamic components
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _backendPosts.length,
              itemBuilder: (context, index) {
                final post = _backendPosts[index];
                
                return FeedPostCard(
                  authorName: post['author_name'] ?? 'Anonymous',
                  authorInitial: post['author_initial'] ?? 'A',
                  timestamp: post['timestamp'] ?? '',
                  content: post['content'] ?? '',
                  commentCount: post['comment_count'] ?? 0,
                  onLikePressed: () {
                    // Handle like logic
                  },
                  onCommentPressed: () {
                    // Handle open comments logic
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: LearnerBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}