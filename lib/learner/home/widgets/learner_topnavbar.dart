import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/shared/services/storage_service.dart';
import 'package:mentra_mobile_view/features/auth/login_screen.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_dropdown.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_controller.dart';
import 'package:mentra_mobile_view/learner/shared/theme_controller.dart';

class LearnerTopNavbar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onSignOutPressed;
  final VoidCallback? onLogoPressed;
  final bool isDarkMode;

  const LearnerTopNavbar({
    super.key,
    this.onMenuPressed,
    this.onThemeToggle,
    this.onProfilePressed,
    this.onSignOutPressed,
    this.isDarkMode = false,
    this.onLogoPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<LearnerTopNavbar> createState() => _LearnerTopNavbarState();
}

class _LearnerTopNavbarState extends State<LearnerTopNavbar> {
  final NotificationController _notificationController = NotificationController();
  Timer? _poller;

  @override
  void initState() {
    super.initState();
    _notificationController.loadNotifications();

    _poller = Timer.periodic(const Duration(seconds: 30), (_) {
      _notificationController.loadNotifications();
    });
  }

  @override
  void dispose() {
    _poller?.cancel();
    _notificationController.dispose();
    super.dispose();
  }

  Future<void> _handleDefaultSignOut(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;
    if (!context.mounted) return;

    await StorageService.clearTokens();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }


  void _showNotifications(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        alignment: Alignment.topCenter,
        child: NotificationDropdown(
          controller: _notificationController,
          statusBarHeight: statusBarHeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- LEFT SIDE: Brand & Role ---
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: widget.onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
              color: const Color(0xFF334155),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
            const SizedBox(width: 2),

            // ALMA Logo + Mentra Title (tap to go home)
            GestureDetector(
              onTap: widget.onLogoPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 26,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/almallc.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.school, size: 16, color: Color(0xFF0284C7)),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    child: Text(
                      'Mentra',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
              ),
            ),

            const Spacer(),

            // --- RIGHT SIDE: Actions & Controls ---
            // Dark Mode Toggle
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, _) {
                final isDark = currentMode == ThemeMode.dark;
                final dynamicBorderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: dynamicBorderColor),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                      size: 16,
                      color: isDark ? Colors.amber : const Color(0xFF1E293B),
                    ),
                    onPressed: widget.onThemeToggle ??
                        () {
                          themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                        },
                  ),
                );
              },
            ),
            const SizedBox(width: 4),

            // Notification Bell
            ListenableBuilder(
              listenable: _notificationController,
              builder: (context, _) {
                final unreadCount = _notificationController.unreadCount;
                final badgeText = unreadCount > 9 ? '9+' : unreadCount.toString();

                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                            child: Text(
                              badgeText,
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
                  onPressed: () => _showNotifications(context),
                );
              },
            ),
            const SizedBox(width: 4),

            // Circular Logout Button
            InkWell(
              onTap: widget.onSignOutPressed ?? () => _handleDefaultSignOut(context),
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
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
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
