import 'package:flutter/material.dart';

class LearnerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LearnerBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F17), // Dark navy matching theme
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E293B), // Subtle dark border line
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF38BDF8), // Active light blue
        unselectedItemColor: const Color(0xFF64748B), // Slate gray
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.home_outlined, size: 24),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.home, size: 24),
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.person_outline, size: 24),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Icon(Icons.person, size: 24),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}