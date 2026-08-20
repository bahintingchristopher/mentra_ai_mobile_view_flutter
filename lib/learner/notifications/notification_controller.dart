import 'package:flutter/material.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_model.dart';
import 'package:mentra_mobile_view/learner/notifications/notification_service.dart';

class NotificationController extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await NotificationService.fetchNotifications();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    final success = await NotificationService.markAllAsRead();
    if (success) {
      await loadNotifications();
    }
  }

  Future<void> markAsRead(int notificationId) async {
    final success = await NotificationService.markAsRead(notificationId);
    if (success) {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          type: _notifications[index].type,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          actorName: _notifications[index].actorName,
          title: _notifications[index].title,
          postId: _notifications[index].postId,
          microtrainingId: _notifications[index].microtrainingId,
        );
        notifyListeners();
      }
    }
  }
}
