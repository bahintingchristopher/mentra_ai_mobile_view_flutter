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
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }
}