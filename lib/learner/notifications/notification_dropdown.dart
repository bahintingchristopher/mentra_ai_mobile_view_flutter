import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_controller.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_model.dart';

class NotificationDropdown extends StatelessWidget {
  final NotificationController controller;
  final ValueChanged<NotificationModel>? onTap;
  final double statusBarHeight;

  const NotificationDropdown({
    super.key,
    required this.controller,
    this.onTap,
    this.statusBarHeight = 0,
  });

  String _timeAgo(dynamic dateInput) {
    if (dateInput == null) return '';
    try {
      final DateTime parsedDate = dateInput is DateTime
          ? dateInput
          : DateTime.parse(dateInput.toString());
      final DateTime now = DateTime.now();
      final Duration diff = now.difference(parsedDate.toLocal());

      if (diff.isNegative) return 'Just now';
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      return DateFormat('MMM d').format(parsedDate.toLocal());
    } catch (_) {
      return '';
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'post_created':
        return Icons.article_outlined;
      case 'microtraining_assigned':
      case 'microtraining_completed':
        return Icons.school_outlined;
      case 'comment_created':
        return Icons.chat_bubble_outline;
      case 'like_created':
        return Icons.favorite_border;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _typeIconColor(String type, bool isDark) {
    switch (type) {
      case 'post_created':
        return const Color(0xFF0EA5E9);
      case 'microtraining_assigned':
        return const Color(0xFF8B5CF6);
      case 'microtraining_completed':
        return const Color(0xFF10B981);
      case 'comment_created':
        return const Color(0xFFF59E0B);
      case 'like_created':
        return const Color(0xFFEF4444);
      default:
        return isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    }
  }

  Color _typeIconBg(String type, bool isDark) {
    switch (type) {
      case 'post_created':
        return isDark ? const Color(0xFF0C4A6E) : const Color(0xFFE0F2FE);
      case 'microtraining_assigned':
        return isDark ? const Color(0xFF2E1065) : const Color(0xFFEDE9FE);
      case 'microtraining_completed':
        return isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
      case 'comment_created':
        return isDark ? const Color(0xFF451A03) : const Color(0xFFFEF3C7);
      case 'like_created':
        return isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2);
      default:
        return isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    }
  }

  String _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 390),
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              left: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              right: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 100 : 25),
                blurRadius: 32,
                offset: const Offset(0, 12),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark),
              Container(
                height: 1,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              ),
              _buildContent(context, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final int unread = controller.unreadCount;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 16, 20, 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0284C7),
                  const Color(0xFF0369A1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withAlpha(60),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                if (unread > 0)
                  Text(
                    '$unread unread',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
              ],
            ),
          ),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unread',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          const SizedBox(width: 10),
          InkWell(
            onTap: unread > 0 ? () => controller.markAllAsRead() : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: unread > 0
                      ? const Color(0xFF0284C7)
                      : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close_rounded,
                size: 22,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    if (controller.isLoading) {
      return _buildLoadingState(isDark);
    }

    if (controller.notifications.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          ),
        ),
        itemBuilder: (context, index) {
          final NotificationModel item = controller.notifications[index];
          final bool isUnread = !item.isRead;

          return _NotificationItem(
            item: item,
            isUnread: isUnread,
            isDark: isDark,
            timeAgo: _timeAgo(item.createdAt),
            typeIcon: _typeIcon(item.type),
            typeIconColor: _typeIconColor(item.type, isDark),
            typeIconBg: _typeIconBg(item.type, isDark),
            initials: _initials(item.actorName),
            onTap: onTap != null ? () => onTap!(item) : null,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index < 2 ? 14.0 : 0),
            child: Row(
              children: [
                _shimmerBox(40, 40, 20, isDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(120, 12, 6, isDark),
                      const SizedBox(height: 8),
                      _shimmerBox(80, 10, 5, isDark),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, double radius, bool isDark) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 32,
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'You\'re all caught up!',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel item;
  final bool isUnread;
  final bool isDark;
  final String timeAgo;
  final IconData typeIcon;
  final Color typeIconColor;
  final Color typeIconBg;
  final String initials;
  final VoidCallback? onTap;

  const _NotificationItem({
    required this.item,
    required this.isUnread,
    required this.isDark,
    required this.timeAgo,
    required this.typeIcon,
    required this.typeIconColor,
    required this.typeIconBg,
    required this.initials,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnread
              ? (isDark ? const Color(0xFF0C2D48) : const Color(0xFFF0F9FF))
              : Colors.transparent,
          border: isUnread
              ? Border(
                  left: BorderSide(
                    color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                    width: 3,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: typeIconBg,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      typeIcon,
                      size: 11,
                      color: typeIconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                      height: 1.4,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 11,
                        color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isUnread)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
