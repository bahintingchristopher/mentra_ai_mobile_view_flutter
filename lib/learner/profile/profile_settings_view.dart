import 'package:flutter/material.dart';
import 'personal_info/personal_info_view.dart';
import 'change_password/change_password_view.dart';
import 'notifications/notifications_view.dart';
import 'rewards/rewards_view.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0D1322) : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF434B5E) : Colors.white,
          elevation: 0,
          title: Text(
            'Profile Settings',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: const Color(0xFF38BDF8),
            unselectedLabelColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
            indicatorColor: const Color(0xFF38BDF8),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Personal Information'),
              Tab(text: 'Change Password'),
              Tab(text: 'Notifications'),
              Tab(text: 'Rewards'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PersonalInfoView(),
            ChangePasswordView(),
            NotificationsView(),
            RewardsView(),
          ],
        ),
      ),
    );
  }
}