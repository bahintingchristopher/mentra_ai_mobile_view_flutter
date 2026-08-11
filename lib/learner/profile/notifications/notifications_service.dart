import 'notifications_model.dart';

class NotificationsService {
  Future<NotificationsModel> fetchSettings() async {
    // Replace with API endpoint GET
    await Future.delayed(const Duration(milliseconds: 200));
    return NotificationsModel(enableEmailNotifications: true);
  }

  Future<bool> updateSettings(NotificationsModel settings) async {
    // Replace with API endpoint PUT
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}