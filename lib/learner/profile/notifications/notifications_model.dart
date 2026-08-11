class NotificationsModel {
  bool enableEmailNotifications;

  NotificationsModel({required this.enableEmailNotifications});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      enableEmailNotifications: json['enable_email_notifications'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_email_notifications': enableEmailNotifications,
    };
  }
}