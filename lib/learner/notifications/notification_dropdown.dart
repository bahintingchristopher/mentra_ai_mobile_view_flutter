import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_controller.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_model.dart';

class NotificationDropdown extends StatelessWidget {
  final NotificationController controller;

  const NotificationDropdown({
    super.key,
    required this.controller,
  });

  String _formatDate(dynamic dateInput) {
    if (dateInput == null) return '';
    try {
      final DateTime parsedDate = dateInput is DateTime 
          ? dateInput 
          : DateTime.parse(dateInput.toString());
      return DateFormat('M/d/yyyy, h:mm:ss a').format(parsedDate.toLocal());
    } catch (_) {
      return dateInput.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          width: 320,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, 
                blurRadius: 8, 
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.markAllAsRead(),
                      child: const Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0284C7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Notification List
              Flexible(
                child: controller.isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : controller.notifications.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'No notifications',
                                style: TextStyle(
                                  color: Color(0xFF64748B), 
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: controller.notifications.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final NotificationModel item = controller.notifications[index];
                              final bool isUnread = !item.isRead;

                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Unread Indicator Dot
                                    Container(
                                      margin: const EdgeInsets.only(top: 5, right: 10),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isUnread
                                            ? const Color(0xFF0284C7)
                                            : Colors.transparent,
                                      ),
                                    ),
                                    // Title & Date
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: isUnread 
                                                  ? FontWeight.w600 
                                                  : FontWeight.normal,
                                              color: const Color(0xFF1E293B),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(item.createdAt),
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}