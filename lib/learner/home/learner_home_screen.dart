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
  String? _sessionKey;

  bool _isFeedSelected = true;
  String _selectedStatus = 'pending';

  final TextEditingController _searchController =
      TextEditingController();

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

  // ------------------------------------------------------------
  // LOAD FEED
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // LOAD MICROTRAININGS
  // ------------------------------------------------------------

  void _loadMicrotrainings() async {
    final token = await StorageService.getAccessToken();

    setState(() {
      _microtrainingFuture =
          MicrotrainingService.getMicrotrainings(
        accessToken: token ?? '',
        status: _selectedStatus,
        searchQuery: _searchController.text,
      ).then(
        (dataList) => dataList
            .map(
              (json) => MicrotrainingModel.fromJson(json),
            )
            .toList(),
      );
    });
  }

  // ------------------------------------------------------------
  // DRAWER
  // ------------------------------------------------------------

  Widget _buildLearnerDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Drawer(
      width: 285,

      // Remove default Drawer shadow behavior if desired
      elevation: 8,

      child: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // DRAWER HEADER
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                12,
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
                      color: theme.colorScheme.onSurface,
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
                      color:
                          isDark
                              ? Colors.white70
                              : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // DRAWER CONTENT
            // --------------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // ------------------------------------------------
                    // LOCAL TIME CARD
                    // ------------------------------------------------

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF8FAFC),
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              isDark
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
                                color:
                                    isDark
                                        ? const Color(
                                            0xFF94A3B8,
                                          )
                                        : const Color(
                                            0xFF64748B,
                                          ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Local Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w500,
                                  color:
                                      isDark
                                          ? const Color(
                                              0xFFCBD5E1,
                                            )
                                          : const Color(
                                              0xFF475569,
                                            ),
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
                              color:
                                  theme
                                      .colorScheme
                                      .onSurface,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            _getCurrentDate(),
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isDark
                                      ? const Color(
                                          0xFF94A3B8,
                                        )
                                      : const Color(
                                          0xFF64748B,
                                        ),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Asia/Manila',
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  isDark
                                      ? const Color(
                                          0xFF64748B,
                                        )
                                      : const Color(
                                          0xFF94A3B8,
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // YOUR PROGRESS
                    // ------------------------------------------------

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(24),
                        border: Border.all(
                          color:
                              isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.06),
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
                          Text(
                            'YOUR PROGRESS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  const Color(
                                    0xFF0284C7,
                                  ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          _progressRow(
                            label: 'Streak',
                            value: '0',
                            subtitle: 'days in a row',
                            color:
                                theme
                                    .colorScheme
                                    .onSurface,
                          ),

                          const Divider(height: 24),

                          _progressRow(
                            label: 'XP',
                            value: '0',
                            subtitle: 'points earned',
                            color:
                                const Color(
                                  0xFF0EA5E9,
                                ),
                          ),

                          const Divider(height: 24),

                          _progressRow(
                            label: 'Queued',
                            value: '4',
                            subtitle:
                                'trainings waiting',
                            color:
                                const Color(
                                  0xFFD4A800,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ------------------------------------------------
                    // QUICK ACTIONS
                    // ------------------------------------------------

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(24),
                        border: Border.all(
                          color:
                              isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.06),
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
                                BorderRadius.circular(
                              16,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pop();

                              setState(() {
                                _currentNavIndex = 1;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 16,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isDark
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
                                  color:
                                      isDark
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
                                  color:
                                      isDark
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

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PROGRESS ROW
  // ------------------------------------------------------------

  Widget _progressRow({
    required String label,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      theme
                          .colorScheme
                          .onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      theme
                          .colorScheme
                          .onSurface
                          .withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TIME
  // ------------------------------------------------------------

  String _getCurrentTime() {
    final now = DateTime.now();

    final hour =
        now.hour == 0
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
                    _selectedStatus =
                        newStatus;
                    _loadMicrotrainings();
                  });
                },
                onSearchChanged:
                    (_) => _loadMicrotrainings(),
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
                    microtrainingFuture:
                        _microtrainingFuture,
                  ),
          ],
        ),
      ),

      // ----------------------------------------------------------
      // INDEX 1: PROFILE
      // ----------------------------------------------------------

      Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
            color:
                theme
                    .colorScheme
                    .onSurface,
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

      // ==========================================================
      // THIS IS THE IMPORTANT PART
      // ==========================================================

      drawer: _buildLearnerDrawer(context),

      // ==========================================================

      appBar: const LearnerTopNavbar(),

      body: IndexedStack(
        index: _currentNavIndex,
        children: pages,
      ),

      bottomNavigationBar:
          LearnerBottomNav(
        currentIndex:
            _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex =
                index;
          });
        },
      ),
    );
  }
}