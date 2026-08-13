class ChangePasswordModel {
  String currentPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswordModel({
    this.currentPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'old_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirm': confirmPassword,
    };
  }
}