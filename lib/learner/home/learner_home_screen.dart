import 'package:flutter/material.dart';

import 'package:mentra_mobile_view/learner/home/widgets/home_header.dart';
import 'package:mentra_mobile_view/learner/home/widgets/learner_bottomnav.dart';
import 'package:mentra_mobile_view/learner/home/widgets/learner_topnavbar.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_filters.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_model.dart';
import 'package:mentra_mobile_view/learner/feeds/feeds_service.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_service.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';
import 'package:mentra_mobile_view/learner/feeds/feed_view.dart';
import 'package:mentra_mobile_view/learner/microtrainings/microtraining_view.dart';
import 'package:mentra_mobile_view/learner/feeds/feed_model.dart';

class LearnerHome extends StatefulWidget {
  const LearnerHome({super.key});

  @override
  State<LearnerHome> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHome> {
  int _currentNavIndex = 0;
  String _accessToken = '';
  String? _sessionKey ;
  bool _isFeedSelected = true;
  String _selectedStatus = 'pending';
  final TextEditingController _searchController = TextEditingController();

  late Future<List<FeedPost>> _feedFuture;
  late Future<List<MicrotrainingModel>> _microtrainingFuture;

  @override
  void initState() {
    super.initState();
    _loadFeed();
    _loadMicrotrainings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFeed() async {
    final token = await StorageService.getAccessToken();
    final sessionKey = await StorageService.getSessionKey();
    setState(() {

      _accessToken = token ?? '';
      _sessionKey = sessionKey ?? '';

      _feedFuture = ApiService.fetchFeedPosts(
        accessToken: token ?? '',
        sessionKey: sessionKey ?? '',
      );
    });
  }

  void _loadMicrotrainings() async {
    final token = await StorageService.getAccessToken();
    setState(() {
      _microtrainingFuture = MicrotrainingService.getMicrotrainings(
        accessToken: token ?? '',
        status: _selectedStatus,
        searchQuery: _searchController.text,
      ).then((dataList) => dataList.map((json) => MicrotrainingModel.fromJson(json)).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // List of page views for the bottom navigation bar
    final List<Widget> pages = [
      // Index 0: Main Feed & Microtrainings View
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Component
            HomeHeader(
              isFeedSelected: _isFeedSelected,
              onSelectMicrotrainings: () => setState(() => _isFeedSelected = false),
              onSelectFeed: () => setState(() => _isFeedSelected = true),
            ),
            const SizedBox(height: 20),

            // Filters Component (Microtrainings only)
            if (!_isFeedSelected) ...[
              MicrotrainingFilters(
                selectedStatus: _selectedStatus,
                searchController: _searchController,
                onStatusChanged: (newStatus) {
                  setState(() {
                    _selectedStatus = newStatus;
                    _loadMicrotrainings();
                  });
                },
                onSearchChanged: (_) => _loadMicrotrainings(),
              ),
              const SizedBox(height: 16),
            ],

            // Content Views
            _isFeedSelected
                ? FeedView(
                  feedFuture: _feedFuture,
                  accessToken: _accessToken,
                  sessionKey: _sessionKey,
                  onCommentAdded: () {
                    // Refresh the feed when a comment is added
                    _loadFeed();
                  },
                )
                : MicrotrainingView(microtrainingFuture: _microtrainingFuture),
          ],
        ),
      ),

      // Index 1: Profile View
      Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const LearnerTopNavbar(),
      body: IndexedStack(
        index: _currentNavIndex,
        children: pages,
      ),
      bottomNavigationBar: LearnerBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
      ),
    );
  }
}