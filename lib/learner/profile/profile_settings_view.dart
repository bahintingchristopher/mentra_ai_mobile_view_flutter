import 'package:flutter/material.dart';
import 'personal_info/personal_info_view.dart';
import 'change_password/change_password_view.dart';
import 'notifications/notifications_view.dart';
import 'rewards/rewards_view.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Profile Settings',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Dashboard'),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF38BDF8),
            unselectedLabelColor: Color(0xFF64748B),
            indicatorColor: Color(0xFF38BDF8),
            indicatorWeight: 3,
            tabs: [
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