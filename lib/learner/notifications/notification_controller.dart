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
    await loadNotifications(); // Fresh fetch updates the entire list safely
  }
}
}