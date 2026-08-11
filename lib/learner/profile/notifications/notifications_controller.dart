import 'package:flutter/material.dart';
import 'notifications_model.dart';
import 'notifications_service.dart';

class NotificationsController extends ChangeNotifier {
  final NotificationsService _service = NotificationsService();

  NotificationsModel settings = NotificationsModel(enableEmailNotifications: true);
  bool isLoading = false;

  Future<void> loadSettings() async {
    isLoading = true;
    notifyListeners();

    settings = await _service.fetchSettings();

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleEmailNotifications(bool val) async {
    settings.enableEmailNotifications = val;
    notifyListeners();
    await _service.updateSettings(settings);
  }
}