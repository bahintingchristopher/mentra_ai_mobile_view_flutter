import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/services/storage_service.dart';
import 'package:mentra_mobile_view/views/screens/login_screen.dart';

class LearnerTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onSignOutPressed;
  final bool isDarkMode;
  final String notificationCount;

  const LearnerTopNavbar({
    super.key,
    this.onMenuPressed,
    this.onThemeToggle,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onSignOutPressed,
    this.isDarkMode = false,
    this.notificationCount = '9+',
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  // Default logout implementation
  Future<void> _handleDefaultSignOut(BuildContext context) async {
    await StorageService.clearTokens();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return SafeArea(
      child: Container(
        height: 60,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- LEFT SIDE: Brand & Role ---
            IconButton(
              icon: const Icon(Icons.menu, size: 22),
              onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
              color: const Color(0xFF334155),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 2),

            // ALMA Logo
            Container(
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Image.network(
                '../assets/alma_logo.png',
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.school, size: 16, color: Color(0xFF0284C7)),
              ),
            ),
            const SizedBox(width: 4),

            // Mentra Title
            const Text(
              'Mentra',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 4),

            // Learner Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFA8E6CF)),
              ),
              child: const Text(
                'Learner',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D8A50),
                ),
              ),
            ),

            const Spacer(),

            // --- RIGHT SIDE: Actions & Controls ---
            // Dark Mode Toggle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                  size: 16,
                  color: const Color(0xFF1E293B),
                ),
                onPressed: onThemeToggle,
              ),
            ),
            const SizedBox(width: 4),

            // Notification Bell
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.notifications_none_rounded, size: 20),
                  color: const Color(0xFF334155),
                  onPressed: onNotificationPressed,
                ),
                if (notificationCount.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        notificationCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),

            // Profile Avatar ("B")
            GestureDetector(
              onTap: onProfilePressed,
              child: const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF0EA5E9),
                child: Text(
                  'B',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),

            // --- SMALL CIRCULAR BLUE LOGOUT BUTTON ---
            InkWell(
              onTap: onSignOutPressed ?? () => _handleDefaultSignOut(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxConstraints() != null
                        ? BoxShadow(
                            color: const Color(0xFF0284C7).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        : const BoxShadow(),
                  ],
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}