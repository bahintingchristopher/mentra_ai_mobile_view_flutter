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
import 'package:mentra_mobile_view/learner/progress_bar/progress_bar_view.dart';
import 'package:mentra_mobile_view/learner/profile/profile_settings_view.dart';

class LearnerHome extends StatefulWidget {
  const LearnerHome({super.key});

  @override
  State<LearnerHome> createState() => _LearnerHomeState();
}

class _LearnerHomeState extends State<LearnerHome> {
  int _currentNavIndex = 0;

  String _accessToken = '';
  String? _sessionKey;

  bool _isFeedSelected = true;
  String _selectedStatus = 'pending';

  final TextEditingController _searchController =
      TextEditingController();

  late Future<List<FeedPost>> _feedFuture;
  List<MicrotrainingModel> _allMicrotrainings = [];
  List<MicrotrainingModel> _filteredMicrotrainings = [];
  bool _microtrainingLoading = false;
  String? _microtrainingError;

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

  // ------------------------------------------------------------
  // LOAD FEED
  // ------------------------------------------------------------

  void _loadFeed() {
    setState(() {
      _feedFuture = () async {
        final token = await StorageService.getAccessToken();
        final sessionKey = await StorageService.getSessionKey();

        if (mounted) {
          setState(() {
            _accessToken = token ?? '';
            _sessionKey = sessionKey ?? '';
          });
        }

        return ApiService.fetchFeedPosts(
          accessToken: token ?? '',
          sessionKey: sessionKey ?? '',
        );
      }();
    });
  }

  // ------------------------------------------------------------
  // LOAD MICROTRAININGS
  // ------------------------------------------------------------

  void _loadMicrotrainings() async {
    setState(() {
      _microtrainingLoading = true;
      _microtrainingError = null;
    });

    final token = await StorageService.getAccessToken();

    try {
      final dataList = await MicrotrainingService.getMicrotrainings(
        accessToken: token ?? '',
        status: _selectedStatus,
      );

      if (!mounted) return;

      setState(() {
        _allMicrotrainings = dataList
            .map((json) => MicrotrainingModel.fromJson(json))
            .toList();
        _microtrainingLoading = false;
        _filteredMicrotrainings = _computeFilteredMicrotrainings();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _microtrainingLoading = false;
        _microtrainingError = e.toString();
      });
    }
  }

  List<MicrotrainingModel> _computeFilteredMicrotrainings() {
    final query = _searchController.text.trim().toLowerCase();
    final status = _selectedStatus.toLowerCase();

    return _allMicrotrainings.where((m) {
      if (m.status.toLowerCase() != status) return false;

      if (query.isEmpty) return true;

      final haystack = [
        m.title,
        m.description ?? '',
        ...m.categories,
        m.pendingStatusText,
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();
  }

  void _applyMicrotrainingFilters() {
    setState(() {
      _filteredMicrotrainings = _computeFilteredMicrotrainings();
    });
  }

  // ------------------------------------------------------------
  // OPEN DRAWER
  // ------------------------------------------------------------

  void _openLearnerDrawer() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close drawer',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final theme = Theme.of(context);

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: _buildLearnerDrawer(context, theme),
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DRAWER
  // ------------------------------------------------------------

  Widget _buildLearnerDrawer(
    BuildContext context,
    ThemeData theme,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 285,
        maxHeight: MediaQuery.of(context).size.height - 32,
      ),
      child: Container(
        width: 285,
        margin: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 20,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // --------------------------------------------------
                // DRAWER HEADER
                // --------------------------------------------------

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    12,
                    0,
                    12,
                  ),
                  child: Row(
                    children: [

                      // ALMA LOGO
                      Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Image.asset(
                          'assets/almallc.jpg',
                          errorBuilder:
                              (context, error, stackTrace) {
                            return const Icon(
                              Icons.school,
                              size: 18,
                              color: Color(0xFF0284C7),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // MENTRA
                      Text(
                        'Mentra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme
                              .colorScheme
                              .onSurface,
                        ),
                      ),

                      const Spacer(),

                      // CLOSE BUTTON
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // --------------------------------------------------
                // LOCAL TIME CARD
                // --------------------------------------------------

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius:
                        BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            'Local Time',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        _getCurrentTime(),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: theme
                              .colorScheme
                              .onSurface,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        _getCurrentDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Asia/Manila',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // --------------------------------------------------
                // YOUR PROGRESS
                // --------------------------------------------------

                _accessToken.isEmpty
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                          child:
                              CircularProgressIndicator(),
                        ),
                      )
                    : ProgressBarView(
                        accessToken: _accessToken,
                      ),

                const SizedBox(height: 16),

                // --------------------------------------------------
                // QUICK ACTIONS
                // --------------------------------------------------

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius:
                        BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'QUICK ACTIONS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF0284C7),
                        ),
                      ),

                      const SizedBox(height: 16),

                      InkWell(
                        borderRadius:
                            BorderRadius.circular(16),
                        onTap: () {
                          Navigator.of(context).pop();

                          setState(() {
                            _currentNavIndex = 1;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          decoration:
                              BoxDecoration(
                            color: isDark
                                ? const Color(
                                    0xFF1E293B,
                                  )
                                : const Color(
                                    0xFFF8FAFC,
                                  ),
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                            border: Border.all(
                              color: isDark
                                  ? const Color(
                                      0xFF334155,
                                    )
                                  : const Color(
                                      0xFFE2E8F0,
                                    ),
                            ),
                          ),
                          child: Text(
                            'View Profile',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
                              color: isDark
                                  ? const Color(
                                      0xFFCBD5E1,
                                    )
                                  : const Color(
                                      0xFF475569,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Small bottom spacing
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TIME
  // ------------------------------------------------------------

  String _getCurrentTime() {
    final now = DateTime.now();

    final hour = now.hour == 0
        ? 12
        : now.hour > 12
            ? now.hour - 12
            : now.hour;

    final minute =
        now.minute.toString().padLeft(2, '0');

    final second =
        now.second.toString().padLeft(2, '0');

    final period =
        now.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute:$second $period';
  }

  // ------------------------------------------------------------
  // DATE
  // ------------------------------------------------------------

  String _getCurrentDate() {
    final now = DateTime.now();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    const weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return '${weekdays[now.weekday - 1]}, '
        '${months[now.month - 1]} '
        '${now.day}, '
        '${now.year}';
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> pages = [

      // ----------------------------------------------------------
      // INDEX 0: FEED / MICROTRAININGS
      // ----------------------------------------------------------

      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            HomeHeader(
              isFeedSelected:
                  _isFeedSelected,

              onSelectMicrotrainings:
                  () => setState(
                () => _isFeedSelected = false,
              ),

              onSelectFeed:
                  () => setState(
                () => _isFeedSelected = true,
              ),
            ),

            const SizedBox(height: 20),

            if (!_isFeedSelected) ...[

              MicrotrainingFilters(
                selectedStatus:
                    _selectedStatus,

                searchController:
                    _searchController,

                onStatusChanged:
                    (newStatus) {
                  setState(() {
                    _selectedStatus = newStatus;
                  });
                  _applyMicrotrainingFilters();
                },

                onSearchChanged:
                    (_) => _applyMicrotrainingFilters(),
              ),

              const SizedBox(height: 16),
            ],

            _isFeedSelected
                ? FeedView(
                    feedFuture:
                        _feedFuture,
                    accessToken:
                        _accessToken,
                    sessionKey:
                        _sessionKey,
                    onCommentAdded: () {
                      _loadFeed();
                    },
                  )
                : MicrotrainingView(
                    items: _filteredMicrotrainings,
                    loading: _microtrainingLoading,
                    error: _microtrainingError,
                    onRetry: _loadMicrotrainings,
                  ),
          ],
        ),
      ),

      // ----------------------------------------------------------
      // INDEX 1: PROFILE SETTINGS
      // ----------------------------------------------------------

      const ProfileSettingsView(),
    ];

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      // IMPORTANT:
      // We are NOT using Scaffold.drawer anymore.

      appBar: LearnerTopNavbar(
        onMenuPressed: _openLearnerDrawer,
      ),

      body: IndexedStack(
        index: _currentNavIndex,
        children: pages,
      ),

      bottomNavigationBar: LearnerBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }
}